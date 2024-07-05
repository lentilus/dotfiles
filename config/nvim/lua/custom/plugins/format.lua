return {
    'stevearc/conform.nvim',
    opts = {
        notify_on_error = true,
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters = {
            latexcustom = {
                command = "latexindent",
                args = { "-m" }
            }
        },
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { "isort", "black" },
            go = { "gofumt", "goimports", "golines" },
            tex = { "latexcustom" },
        },
    }
}
