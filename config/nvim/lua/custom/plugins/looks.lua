return {

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup()
            vim.cmd("colorscheme gruvbox")
        end
    },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.opt.termguicolors = true
    --
    --         function SetColor(color)
    --             color = color or "catppuccin" -- have a default value
    --             vim.cmd.colorscheme(color)
    --
    --             vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --             vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --             vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#330000" })
    --         end
    --
    --         SetColor() -- run at startup
    --     end
    -- },
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
