return {
	"stevearc/conform.nvim",
	dependencies = { "lewis6991/gitsigns.nvim" },
	config = function()
		require("custom.conform")
	end,
}
