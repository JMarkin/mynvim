local M = {}

M.plugin = {
    name = "nvim-window",
    url = "https://gitlab.com/yorickpeterse/nvim-window",
    event = "BufAdd",
    config = function()
        vim.keymap.set({ "n", "v" }, "<space>w", require("nvim-window").pick, { silent = true, desc = "Windows: pick" })
    end,
}

return M
