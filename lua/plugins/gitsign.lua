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
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Git: stage hunk" })
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Git: reset hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "Git: stage buffer" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git: undo stage hunk" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "Git: reset buffer" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Git: preview hunk" })
        map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
        end, { desc = "Git: blame line full" })
        map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Git: toggle current line blame" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Git: diff this" })
        map("n", "<leader>gD", function()
            gs.diffthis("~")
        end, { desc = "Git: diff all" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Git: toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select hunk" })
    end,
})
