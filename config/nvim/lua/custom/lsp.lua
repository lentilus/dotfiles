local cmp_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

local function zeta_def(client, bufnr)
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
			cmd = { "/home/lentilus/git/zeta.git/dev/bin/zeta" },
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

lspconfig.nixd.setup({
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				home_manager = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."lentilus@fedora".options',
				},
			},
		},
	},
})

lspconfig.tinymist.setup({
	cmd = { "tinymist" },
	single_file_support = true,
	settings = {
		tinymist = {
			outputPath = "$root/$dir/$name", -- Example: store artifacts in a target directory
			rootPath = "-", -- Use parent directory of the file as root
		},
	},
	root_dir = require("lspconfig.util").root_pattern(".git", "*.typ"), -- Example root directory logic
})

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

lspconfig.gopls.setup({
	capabilities = capabilities,
	cmd = { "gopls" },
	fileypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			usePlaceholders = true,
		},
	},
})

vim.diagnostic.config({
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
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
