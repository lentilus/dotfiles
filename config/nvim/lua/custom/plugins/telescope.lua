return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/git-worktree.nvim",
			{
				"lentilus/xk.nvim",
				{ dev = true },
			},
		},
		config = function()
			require("custom.telescope")
		end,
	},
}
