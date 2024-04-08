return {
    {
        "lewis6991/gitsigns.nvim",
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
                            gs.next_hunk({ preview = true })
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk({ preview = true })
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: prev hunk" })

                    -- Actions
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Git: blame line full" })
                end,
            })
        end,
        event = { "FileReadPre", "BufReadPre" },
        keys = {
            "<leader>gS",
            "<leader>gu",
            "<leader>gb",
            "[c",
            "]c",
            { "<space>s", ":Gitsign stage_hunk<cr>", desc = "Git: stage hunk", mode = { "n", "v" } },
            { "<space>S", ":Gitsign stage_buffer<cr>", desc = "Git: stage buffer" },
            { "<space>u", ":Gitsign undo_stage_hunk<cr>", desc = "Git: undo stage hunk", mode = { "n", "v" } },
            { "<leader>gr", ":Gitsign reset_hunk<cr>", desc = "Git: reset hunk", mode = { "n", "v" } },
            { "<leader>gR", ":Gitsign reset_buffer<cr>", desc = "Git: reset buffer" },
            { "<leader>gp", ":Gitsign preview_hunk_inline<cr>", desc = "Git: preview hunk" },
            { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git: select hunk", mode = { "o", "x" } },
        },
    },
}
