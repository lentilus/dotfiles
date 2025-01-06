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
            -- compile the pdf but dont view it
            vim.g.typst_pdf_viewer = 'previewpdf --root .'
            
            -- auto watch typst files
			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = "*.typ",
				callback = function()
                end
			})

            -- auto-switching preview
			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "*.typ",
				callback = function(args)
                    local bufnr = args.buf

                    -- if already being watched just switch pdf
                    if vim.b[bufnr].typstwatch then
                        path = vim.api.nvim_buf_get_name(bufnr)
                        pdf = vim.fn.fnamemodify(path, ":r") .. ".pdf"
                        vim.fn.jobstart("previewpdf " .. pdf, {detach = true})
                        return
                    end

                    vim.cmd.TypstWatch()
                    vim.b[bufnr].typstwatch = true
				end,
			})

            local function journal()
                local date = os.date("%d-%m-%y")
                local filename = date .. ".typ"
                local journal_path = vim.fn.expand("~/git/zettelkasten/journal/" .. filename)
                local template_path = vim.fn.expand("~/git/zettelkasten/file-template.typ")

                if vim.fn.filereadable(journal_path) == 1 then
                    vim.cmd("edit " .. journal_path)
                else
                    -- Check if the template file is readable
                    local template_content = {}
                    if vim.fn.filereadable(template_path) == 1 then
                        template_content = vim.fn.readfile(template_path)
                    end

                    vim.cmd("enew") -- Create a new buffer
                    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content) -- Set buffer lines
                    vim.api.nvim_buf_set_name(0, journal_path)
                end

                vim.bo.filetype = "typst"
            end


            -- set buffer local keymaps
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "typst",
                callback = function()
                    vim.keymap.set("n", "<leader>jj", journal, { buffer = true })
                    vim.keymap.set("n", "<leader>ll", vim.cmd.TypstWatch, { buffer = true })
                end,
            })

        end
    }
}
