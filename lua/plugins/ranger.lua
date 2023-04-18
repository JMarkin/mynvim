local M = {}

M.plugin = {
    "kevinhwang91/rnvimr",
    enabled = false,
    keys = { "<A-f>", "<space>f" },
    cmd = "RnvimrToggle",
    init = function()
        vim.keymap.set("n", { "<A-f>", "<space>f" }, ":RnvimrToggle<CR>", { desc = "Ranger" })
        vim.keymap.set("t", "<A-i>", "<C-\\><C-n>:RnvimrResize<CR>", { desc = "Ranger" })
        vim.keymap.set("t", "<A-i>", "<C-\\><C-n>:RnvimrToggle<CR>", { desc = "Ranger" })
        vim.g.rnvimr_hide_gitignore = 0
    end,
}

return M
