return {
	{
		"arne314/typstar",
		branch = "dev",
		ft = { "typst", "typ" },
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		config = function()
			require("typstar").setup()
		end,
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy=false,
        config = function()
            vim.g.typst_pdf_viewer = 'echo'
            
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*.typ",
				callback = function(args)
                    -- print("entered buffer.")

                    path = vim.api.nvim_buf_get_name(args.buf)
                    pdf = vim.fn.fnamemodify(path, ":r") .. ".pdf"
                    -- print(pdf)
                    vim.fn.jobstart("previewpdf " .. pdf)
				end,
			})

        end
    }
}
