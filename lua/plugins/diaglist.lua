local M = {}

M.plugin = {
    "onsails/diaglist.nvim",
    opts = {
        debounce_ms = 150,
    },
    keys = { "<space>E", "<space>e" },
    config = function()
        vim.keymap.set({ "n" }, "<space>E", require("diaglist").open_all_diagnostics, { desc = "All Diagnostics" })
        vim.keymap.set(
            { "n" },
            "<space>e",
            require("diaglist").open_buffer_diagnostics,
            { desc = "Buffer Diagnostics" }
        )
    end,
}

return M
