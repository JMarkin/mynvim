local M = {}

M.plugin = {
    "mrjones2014/smart-splits.nvim",
    enabled = true,
    config = function()
        require("smart-splits").setup({
            multiplexer_integration = 'tmux'
        })

        vim.keymap.set(
            { "n" },
            { "<C-l>" },
            require("smart-splits").move_cursor_right,
            { silent = true, desc = "right" }
        )
        vim.keymap.set({ "n" }, { "<C-j>" }, require("smart-splits").move_cursor_down, { silent = true, desc = "down" })
        vim.keymap.set({ "n" }, { "<C-k>" }, require("smart-splits").move_cursor_up, { silent = true, desc = "top" })
        vim.keymap.set({ "n" }, { "<C-h>" }, require("smart-splits").move_cursor_left, { silent = true, desc = "left" })

        vim.keymap.set(
            { "n" },
            { "<A-h>" },
            require("smart-splits").resize_left,
            { silent = true, desc = "Resize left" }
        )
        vim.keymap.set(
            { "n" },
            { "<A-j>" },
            require("smart-splits").resize_down,
            { silent = true, desc = "Resize down" }
        )
        vim.keymap.set({ "n" }, { "<A-k>" }, require("smart-splits").resize_up, { silent = true, desc = "Resize up" })
        vim.keymap.set(
            { "n" },
            { "<A-l>" },
            require("smart-splits").resize_right,
            { silent = true, desc = "Resize right" }
        )

        vim.keymap.set("n", "<space><space>h", require("smart-splits").swap_buf_left)
        vim.keymap.set("n", "<space><space>j", require("smart-splits").swap_buf_down)
        vim.keymap.set("n", "<space><space>k", require("smart-splits").swap_buf_up)
        vim.keymap.set("n", "<space><space>l", require("smart-splits").swap_buf_right)

        vim.keymap.set({ "n" }, "<space>r", require("smart-splits").start_resize_mode, { desc = "Resize mode" })
    end,
}

return M
