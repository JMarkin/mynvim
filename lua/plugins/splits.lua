require("smart-splits").setup({
    tmux_integration = false,
})

vim.keymap.set(
    {"n"},
    { "<space><left>", "<C-l>" },
    require("smart-splits").move_cursor_left,
    { silent = true, desc = "left" }
)
vim.keymap.set(
    {"n"},
    { "<space><down>", "<C-j>" },
    require("smart-splits").move_cursor_down,
    { silent = true, desc = "down" }
)
vim.keymap.set({"n"}, { "<space><up>", "<C-k>" }, require("smart-splits").move_cursor_up, { silent = true, desc = "top" })
vim.keymap.set(
    {"n"},
    { "<space><right>", "<C-h>" },
    require("smart-splits").move_cursor_right,
    { silent = true, desc = "right" }
)

vim.keymap.set(
    {"n"},
    { "<space>h", "<A-left>", "<A-h>" },
    require("smart-splits").resize_left,
    { silent = true, desc = "Resize left" }
)
vim.keymap.set(
    {"n"},
    { "<space>j", "<A-down>", "<A-j>" },
    require("smart-splits").resize_down,
    { silent = true, desc = "Resize down" }
)
vim.keymap.set(
    {"n"},
    { "<space>k", "<A-up>", "<A-k>" },
    require("smart-splits").resize_up,
    { silent = true, desc = "Resize up" }
)
vim.keymap.set(
    {"n"},
    { "<space>l", "<A-right>", "<A-l>" },
    require("smart-splits").resize_right,
    { silent = true, desc = "Resize right" }
)

vim.keymap.set({"n"}, "<space>r", require("smart-splits").start_resize_mode, { desc = "Resize mode" })
