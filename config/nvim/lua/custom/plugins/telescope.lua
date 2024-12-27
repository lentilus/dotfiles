return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/git-worktree.nvim",
		},
		config = function()
			require("custom.telescope")
		end,
	},
}
