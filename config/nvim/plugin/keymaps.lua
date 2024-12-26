-- quickfix
vim.keymap.set("n", "<leader>n", vim.cmd.cnext)
vim.keymap.set("n", "<leader>N", vim.cmd.cprevious)

-- use letters as typed in select mode
vim.keymap.set("s", "h", "<BS>ih")
vim.keymap.set("s", "j", "<BS>ij")
vim.keymap.set("s", "k", "<BS>ik")
vim.keymap.set("s", "l", "<BS>il")

-- misc
vim.keymap.set("n", "<leader>sm", "<cmd>messages<CR>")
vim.keymap.set("n", "<leader>so", "<cmd>echo 'sourced file'<CR><cmd>source %<CR>")
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")
