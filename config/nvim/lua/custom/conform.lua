local conform = require("conform")

-- https://github.com/stevearc/conform.nvim/issues/92
local function format_range(hunks)
	if next(hunks) == nil then
		vim.notify("done formatting git hunks", "info", { title = "formatting" })
		return
	end
	local hunk = nil
	while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
		hunk = table.remove(hunks)
	end

	if hunk ~= nil and hunk.type ~= "delete" then
		local start = hunk.added.start
		local last = start + hunk.added.count
		-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
		local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
		local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
		conform.format({ range = range, async = false, lsp_fallback = false }, function()
			vim.defer_fn(function()
				format_range(hunks)
			end, 1)
		end)
	end
end

-- https://github.com/stevearc/conform.nvim/issues/92
function format_diff(bufnr)
	local ignore_filetypes = { "lua" }
	if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
		-- vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
		conform.format({ lsp_fallback = false })
		return
	end

	local hunks = require("gitsigns").get_hunks()
	if hunks == nil then
		conform.format({ lsp_fallback = false })
		return
	end

	format_range(hunks)
end

local opts = {
	notify_on_error = true,

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		go = { "gofumt", "goimports", "golines" },
		typst = { "typstfmt" },
	},

	format_on_save = function()
		format_diff()
	end,
}

conform.setup(opts)

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
