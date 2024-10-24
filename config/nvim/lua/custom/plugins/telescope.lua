return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/git-worktree.nvim",
			{ dir = "~/git/xk.nvim.git/develop" },
		},
		config = function()
			require("custom.telescope")
			require("xettelkasten")
		end,
	},
	--[[
    {
        dir = "~/git/xettelkasten.nvim",
        config = function()
            require("telescope").load_extension("xettelkasten")
            vim.keymap.set("n", "<leader>jn", function() require("xettelkasten.zettel").insert() end)
            vim.keymap.set("n", "<leader>jx", function() require("xettelkasten.zettel").rm() end)
            vim.keymap.set("n", "<leader>jf", function() require("xettelkasten.zettel").grep() end)
            vim.keymap.set("n", "<leader>jm", function() require("xettelkasten.zettel").mv() end)
            vim.keymap.set("n", "<leader>jp", function() require("xettelkasten.git").publish() end)
        end
    }
    --]]
}
