return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"echasnovski/mini.ai",
				version = "*",
				config = function()
					require("mini.ai").setup()
				end,
			},
			{
				"numToStr/Comment.nvim",
				config = function()
					require("Comment").setup()
				end,
			},
			{
				"nvim-treesitter/playground",
			},
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ignore_install = {},
				modules = {},
				ensure_installed = {
					-- "c",
					-- "lua",
					-- "bash",
					-- "vim",
					-- "vimdoc",
					-- "query",
					-- "json",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					disable = {
						"latex",
						-- "typst",
					},
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
