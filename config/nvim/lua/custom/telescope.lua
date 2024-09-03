local telescope = require("telescope")
local builtin = require("telescope.builtin")
local extensions = telescope.extensions

require("git-worktree").setup()

telescope.setup({
    extensions = {
        -- xettelkasten = {},
        git_worktree = {},
    },
    pickers = {
        find_files = { hidden = true }
    }
})
-- telescope.load_extension("xettelkasten")
telescope.load_extension("git_worktree")


vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end)
vim.keymap.set("n", "<leader>gf", function() builtin.git_files() end)
vim.keymap.set("n", "<leader>fg", function() builtin.live_grep() end)
vim.keymap.set("n", "<leader>fb", function() builtin.buffers() end)
vim.keymap.set("n", "<leader>fh", function() builtin.help_tags() end)
vim.keymap.set("n", "<leader>jf", function() extensions.xettelkasten.zettel_find() end)
vim.keymap.set("n", "<leader>jj", function() extensions.xettelkasten.journal_today() end)
vim.keymap.set("n", "<leader>jx", function() extensions.xettelkasten.zettel_rm() end)
vim.keymap.set("n", "<leader>ji", function() extensions.xettelkasten.zettel_insert() end)
vim.keymap.set("n", "<leader>jg", function() extensions.xettelkasten.ref_find() end)
vim.keymap.set("n", "<leader>jr", function() extensions.xettelkasten.ref_insert() end)
vim.keymap.set("n", "<leader>jR", function() extensions.xettelkasten.ref_rm() end)
vim.keymap.set("n", "<leader>jT", function() extensions.xettelkasten.tag_rm() end)
vim.keymap.set("n", "<leader>fw", function() extensions.git_worktree.git_worktrees() end)
