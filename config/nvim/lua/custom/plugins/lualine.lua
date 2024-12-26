return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = function()
		require("lualine").setup({
			options = {
				theme = "gruvbox",
				globalstatus = true,
				component_separators = "|",
				section_separators = "",
			},
		})
	end,
}
