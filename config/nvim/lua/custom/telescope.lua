local telescope = require("telescope")
local builtin = require("telescope.builtin")
local extensions = telescope.extensions

telescope.setup({
	extensions = {
		git_worktree = {},
	},
	pickers = {
		find_files = { hidden = false },
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
