return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	build = "make install_jsregexp",
	config = function()
		require("custom.luasnip")
	end,
}
