local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "black",
        "stylua",
    },
    run_on_start = true,
}
)
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
            local lspconfig = require("lspconfig")
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
            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({
                capabilities = capabilities,
                cmd = { "gopls" },
                fileypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        -- completeUnimportet = true,
                        usePlaceholders = true,
                    }
                }
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
