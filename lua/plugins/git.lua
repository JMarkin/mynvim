return {
    {
        "chrisgrieser/nvim-tinygit",
        lazy = true,
        ft = { "gitrebase", "gitcommit" }, -- so ftplugins are loaded
        dependencies = {
            "stevearc/dressing.nvim",
            "ibhagwan/fzf-lua",
            "rcarriga/nvim-notify", -- optional, but will lack some features without it
        },
        keys = {
            -- stylua: ignore start
            {"<leader>gcc", function() require("tinygit").smartCommit() end, desc = "Git: smartcommit"},
            {"<leader>gp", function() require("tinygit").push() end, desc = "Git: push"},
            {"<leader>gco", function() require("tinygit").amendOnlyMsg({ forcePushIfDiverged = false }) end, desc = "Git: amend only message"},
            {"<leader>gce", function() require("tinygit").amendNoEdit({ forcePushIfDiverged = false }) end, desc = "Git: amend no edit"},
            -- stylua: ignore end
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: prev hunk" })

                    -- Actions
                    map({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Git: stage hunk" })
                    map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Git: reset hunk" })
                    map("n", "<leader>gS", gs.stage_buffer, { desc = "Git: stage buffer" })
                    map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git: undo stage hunk" })
                    map("n", "<leader>gR", gs.reset_buffer, { desc = "Git: reset buffer" })
                    map("n", "<leader>gp", gs.preview_hunk, { desc = "Git: preview hunk" })
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Git: blame line full" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select hunk" })
                end,
            })
        end,
        event = { "BufReadPost", "FileReadPost" },
        keys = "<leader>g",
    },
}
