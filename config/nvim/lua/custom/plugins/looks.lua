return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({ contrast = "hard" })
            vim.cmd("colorscheme gruvbox")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'gruvbox',
                    globalstatus = true,
                    component_separators = "|",
                    section_separators = "",
                }
            }
        end
    },
}
