local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

return {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    keys = { { "<space>T", ":Vista ctags<cr>", desc = "Tagbar" } },
    init = function()
        vim.g.vista_update_on_text_changed = 1
        vim.g.vista_disable_statusline = 1
        vim.g.vista_sidebar_width = 30
        vim.g.vista_sidebar_open_cmd = "30vsplit"
    end,
    config = function()
        autocmd("FileType", {
            group = augroup("vista", { clear = true }),
            pattern = {
                "vista_kind",
                "sagaoutline",
            },
            callback = function(event)
                vim.keymap.set("n", "<space>T", "<cmd>close<cr>", { buffer = event.buf, silent = true })
                vim.cmd([[vertical resize 30]])
            end,
        })
    end,
}
