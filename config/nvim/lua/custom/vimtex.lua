-- vimtex configuration
-- Note: must be sourced before vimtex loads!
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura_simple"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_quickfix_ignore_filters = {
	"Underfull",
	"Overfull",
	"You have requested",
	"Empty bibliography",
}
vim.cmd("let g:vimtex_syntax_custom_cmds = [{'name': 'tx', 'mathmode': 1, 'nextgroup': 'texMathTextArg'}]")

-- autocommand to include inkscape drawings inside latex
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function(_)
		vim.keymap.set("n", "<leader>if", function()
			local drawcmd = "/home/lentilus/git/inktex/src/inktex"
			local title = tostring(vim.api.nvim_get_current_line())
			tex_root = vim.b.vimtex.root

			-- strip whitespace
			title = string.gsub(title, "^%s*(.-)%s*$", "%1")
			-- replace space with _
			local stripped = string.gsub(title, "%s+", "_")
			print(stripped)
			if stripped == "" then
				return
			end
			vim.fn.system({ drawcmd, "new", "-t", stripped, "-p", tex_root .. "/figures" })
			vim.cmd("normal! cc\\inkfig{" .. stripped .. "}")
		end)
	end,
})
