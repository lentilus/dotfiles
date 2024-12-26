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
