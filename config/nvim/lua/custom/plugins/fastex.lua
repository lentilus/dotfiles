return {
    dir = "~/git/fastex.nvim",
    ft = { "latex", "tex" },
    dependencies = {
        "L3MON4D3/LuaSnip",
        "lervag/vimtex",
    },
    config = function()
        require("fastex").setup()
    end
}
