local cmp_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"black",
		"stylua",
	},
	run_on_start = true,
})

-- Define `on_attach` function
local function zeta_def(client, bufnr)
	-- Define the keybind for "go to definition" scoped to this specific client
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<Enter>", function()
		local params = vim.lsp.util.make_position_params()
		client.request("textDocument/definition", params, function(err, result, ctx, config)
			if err then
				vim.notify("LSP error: " .. err.message, vim.log.levels.ERROR)
				return
			end
			vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
		end)
	end, opts)
end

-- Register custom LSP zeta manually
if not configs.zeta then
	configs.zeta = {
		default_config = {
			cmd = { "/home/lentilus/git/zeta.git/graph/bin/zeta" },
			filetypes = { "typst" },
			root_dir = function(fname)
				return lspconfig.util.root_pattern(".zeta")(fname) or nil
			end,
			init_options = {
				reference_query = "(ref) @reference",
				target_regex = "^@(.*)$",
				path_separator = ":",
				canonical_extension = ".typ",
			},
		},
	}
end

-- Now call setup
lspconfig.zeta.setup({
	on_attach = zeta_def,
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"bashls",
		-- "gopls",
	},
	handlers = {
		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,

		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
								"it",
								"describe",
								"before_each",
								"after_each",
							},
						},
					},
				},
			})
		end,
		["gopls"] = function()
			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				fileypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						-- completeUnimportet = true,
						usePlaceholders = true,
					},
				},
			})
		end,

		["tinymist"] = function()
			lspconfig.tinymist.setup({
				settings = {
					tinymist = {
						outputPath = "$root/target/$dir/$name", -- Example: store artifacts in a target directory
						exportPdf = "onSave", -- Export PDFs on file save
						rootPath = "-", -- Use parent directory of the file as root
						semanticTokens = "enable", -- Enable semantic tokens for syntax highlighting
						systemFonts = true, -- Load system fonts for Typst compiler
						fontPaths = { "/usr/share/fonts", "~/custom_fonts" }, -- Custom font paths
						compileStatus = "disable", -- Disable compile status (default for Neovim)
						typstExtraArgs = { "--quiet" }, -- Example: Pass additional arguments to typst CLI
						formatterMode = "typstyle", -- Use typstyle formatter
						formatterPrintWidth = 100, -- Set print width to 100 characters
						completion = {
							triggerOnSnippetPlaceholders = true, -- Trigger completions on snippet placeholders
							postfix = true, -- Enable postfix code completion
							postfixUfcs = true, -- Enable UFCS-style completion
							postfixUfcsLeft = true, -- Enable left-variant UFCS-style completion
							postfixUfcsRight = true, -- Enable right-variant UFCS-style completion
						},
					},
				},
				root_dir = require("lspconfig.util").root_pattern(".git", "*.typ"), -- Example root directory logic
			})
		end,
	},
})

vim.diagnostic.config({
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = event.buf })
		end

		map("gd", require("telescope.builtin").lsp_definitions)
		map("gr", require("telescope.builtin").lsp_references)
		map("gI", require("telescope.builtin").lsp_implementations)
		map("<leader>D", require("telescope.builtin").lsp_type_definitions)
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols)
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)
		map("<leader>rn", vim.lsp.buf.rename)
		map("<leader>ca", vim.lsp.buf.code_action)
		map("K", vim.lsp.buf.hover)
		map("<leader>e", vim.diagnostic.open_float)
		map("gD", vim.lsp.buf.declaration)
	end,
})
-- this is necessary so that language servers are actually loaded
-- because we are lazy laoding lsp-config
vim.api.nvim_exec_autocmds("FileType", {})
