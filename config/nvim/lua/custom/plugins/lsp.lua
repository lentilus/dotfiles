return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "folke/neodev.nvim" },
	config = function()
		require("custom.lsp")
	end,
}
