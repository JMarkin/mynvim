local M = {}

local format = function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls" or client.name == "rust_analyzer"
        end,
        async = true,
    })
end

M.plugin = {
    "Asheq/close-buffers.vim",
    event = "BufAdd",
    config = function()
        vim.keymap.set("n", "<space>bd", "<cmd>Bdelete this<Cr>", { desc = "Buffer: delete current" })
        vim.keymap.set(
            "n",
            "<space>bc",
            "<cmd>doau User CloseNvimFloatPrev<Cr><cmd>Bdelete other<Cr>",
            { desc = "Buffer: delete other" }
        )

        vim.keymap.set("n", "<space>bf", format, { silent = true, desc = "Buffer: format" })
    end,
}

return M
