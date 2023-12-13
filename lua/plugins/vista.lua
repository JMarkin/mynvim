local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

vim.keymap.set("n", "<space>t", ":Vista ctags<cr>", { desc = "Tagbar" })

return {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    init = function()
        vim.g.vista_update_on_text_changed = 1
        vim.g.vista_disable_statusline = 1
    end,
    config = function()
        autocmd("FileType", {
            group = augroup("vista", { clear = true }),
            pattern = {
                "vista_kind",
            },
            callback = function(event)
                vim.keymap.set("n", "<space>t", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end,
        })
    end,
}
