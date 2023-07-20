local M = {}

M.plugin = {
    "Asheq/close-buffers.vim",
    event = { "BufAdd", "BufReadPost", "FileReadPost" },
    config = function()
        vim.keymap.set("n", "<space>bd", "<cmd>Bdelete this<Cr>", { desc = "Buffer: delete current" })
        vim.keymap.set("n", "<space>bc", "<cmd>Bdelete other<Cr>", { desc = "Buffer: delete other" })

        vim.keymap.set("n", "<space>bf", require("plugins.lsp").format, { silent = true, desc = "Buffer: format" })
    end,
}

return M
