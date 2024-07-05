return {
    "tpope/vim-fugitive",
    keys = {
        -- git status
        { "<leader>gs", vim.cmd.Git },
        { "<leader>gm", function() vim.cmd("Gvdiffsplit!") end },
    },
    config = function()
        local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = Fugitive,
            pattern = "*",
            callback = function()
                print("hello from fugitive")
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>gpp", function()
                    vim.cmd.Git('push')
                end, opts)

                vim.keymap.set("n", "<leader>gc", function()
                    vim.cmd.Git("commit")
                end, opts);

                vim.keymap.set("n", "<leader>gP", ":Git pull --no-rebase", opts)
                vim.keymap.set("n", "<leader>po", ":Git push --set-upstream origin ", opts);
            end,
        })

        vim.keymap.set("n", "<leader>l", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "<leader>h", "<cmd>diffget //3<CR>")
    end
}
