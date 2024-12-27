-- quickfix
vim.keymap.set("n", "<M-j>", vim.cmd.cnext)
vim.keymap.set("n", "<M-k>", vim.cmd.cprevious)

-- tabs
vim.keymap.set("n", "<M-h>", vim.cmd.tabnext)
vim.keymap.set("n", "<M-l>", vim.cmd.tabprevious)

-- use letters as typed in select mode
vim.keymap.set("s", "h", "<BS>ih")
vim.keymap.set("s", "j", "<BS>ij")
vim.keymap.set("s", "k", "<BS>ik")
vim.keymap.set("s", "l", "<BS>il")

-- misc
vim.keymap.set("n", "<leader>sm", vim.cmd.messages)
vim.keymap.set("n", "<leader>so", "<cmd>echo 'sourced file'<CR><cmd>source %<CR>")
vim.keymap.set("n", "<ESC>", vim.cmd.nohlsearch)
