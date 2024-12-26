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
		"floaterest/typst-preview.nvim", -- allows specifying port
		lazy = false, -- or ft = 'typst'
		-- version = "1.*",
		commit = "bf145b",
		build = function()
			require("typst-preview").update()
		end,
		config = function()
			require("typst-preview").setup({
				debug = true,
				port = 32785,
				open_cmd = "firefox %s --kiosk", -- don't actually start anything here
			})

			-- Global variables for tracking preview state and active buffer
			vim.g.typst_preview_active = false
			vim.g.typst_preview_buffer = nil

			-- Function to handle buffer changes and manage preview state
			local function manage_typst_preview()
				-- Only proceed if Typst preview is active globally
				if not vim.g.typst_preview_active then
					return
				end

				local current_buf = vim.api.nvim_get_current_buf()

				-- Stop Typst preview in the previously active buffer
				print("stopping typst in previous buffer.")
				if vim.g.typst_preview_buffer and vim.g.typst_preview_buffer ~= current_buf then
					vim.api.nvim_buf_call(vim.g.typst_preview_buffer, function()
						vim.cmd("TypstPreviewStop")
						print("Stopped typst preview")
					end)
				end

				-- Start Typst preview in the current buffer
				print("starting typst in new buffer")
				vim.defer_fn(function()
					vim.cmd("TypstPreview")
				end, 200)
				vim.g.typst_preview_buffer = current_buf
			end

			-- Function to toggle Typst preview activation
			local function toggle_preview_var()
				if vim.g.typst_preview_active == false then
					vim.g.typst_preview_active = true
					print("Typst preview enabled")
					manage_typst_preview()
				else
					vim.g.typst_preview_active = false
					print("Typst preview disabled")
				end
			end

			-- Keymap to toggle Typst preview activation
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "typst",
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>ll",
						toggle_preview_var,
						{ buffer = true, desc = "Toggle Typst preview variable" }
					)
				end,
			})

			-- Autocommand to manage preview on buffer enter
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = "*.typ",
				callback = manage_typst_preview,
			})

			-- Autocommand to stop preview when leaving a Typst file
			vim.api.nvim_create_autocmd("BufLeave", {
				pattern = "*.typ",
				callback = function()
					if vim.g.typst_preview_active and vim.g.typst_preview_buffer then
						-- Stop the preview in the buffer being left
						vim.api.nvim_buf_call(vim.g.typst_preview_buffer, function()
							vim.cmd("TypstPreviewStop")
						end)
						vim.g.typst_preview_buffer = nil
					end
				end,
			})
		end,
	},
}
