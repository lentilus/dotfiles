return {
	"neovim/nvim-lspconfig",
	dependencies = { "folke/neodev.nvim" },
	lazy = false,
	config = function()
		require("custom.lsp")
	end,
}
