local telescope = require("telescope")
local builtin = require("telescope.builtin")
local extensions = telescope.extensions

require("git-worktree").setup()

telescope.setup({
	extensions = {
		git_worktree = {},
		xettelkasten = {},
	},
	pickers = {
		find_files = { hidden = true },
	},
})

vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files()
end)
vim.keymap.set("n", "<leader>gf", function()
	builtin.git_files()
end)
vim.keymap.set("n", "<leader>fg", function()
	builtin.live_grep()
end)
vim.keymap.set("n", "<leader>fb", function()
	builtin.buffers()
end)
vim.keymap.set("n", "<leader>fh", function()
	builtin.help_tags()
end)
vim.keymap.set("n", "<leader>fw", function()
	extensions.git_worktree.git_worktrees()
end)
vim.keymap.set("n", "<leader>jf", function()
	extensions.xettelkasten.open_zettel()
end)
vim.keymap.set("n", "<leader>jj", function()
	extensions.xettelkasten.journal()
end)
vim.keymap.set("n", "<leader>ji", function()
	extensions.xettelkasten.new_zettel()
end)
vim.keymap.set("n", "<leader>jx", function()
	extensions.xettelkasten.remove_zettel()
end)
vim.keymap.set("n", "<leader>jr", function()
	extensions.xettelkasten.open_ref()
end)
vim.keymap.set("n", "<leader>jg", function()
	extensions.xettelkasten.grep()
end)
vim.keymap.set("n", "<leader>jm", function()
	extensions.xettelkasten.move_zettel()
end)
vim.keymap.set("n", "<leader>jp", function()
	extensions.xettelkasten.publish_kasten()
end)
