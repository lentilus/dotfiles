return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    version = "e76cb03",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<M-a>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<M-s>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<M-d>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<M-f>", function() harpoon:list():select(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
        -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end
}
