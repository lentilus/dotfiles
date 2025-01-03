vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- add lazy to runtime path
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = false,
	},
	dev = {
		path = "~/git",
		patterns = { "lentilus" },
		fallback = true,
	},
})
