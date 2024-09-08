local groupid = vim.api.nvim_create_augroup
local funcs = require("funcs")
local netrw_funcs = require("extend-netrw.funcs")
local float = require("extend-netrw.float-preview")
local keymap = require("extend-netrw.keymap")

vim.api.nvim_create_autocmd("FileType", {
    group = groupid("netrw", { clear = false }),
    pattern = { "netrw" },
    callback = function(event)
        local win = vim.api.nvim_get_current_win()
        vim.bo[event.buf].buflisted = false
        vim.opt_local.wrap = false
        vim.opt_local.number = false
        vim.opt_local.bufhidden = "wipe"

        keymap.init(event.buf)
        float.attach_netrw(event.buf)

        -- vim.api.nvim_create_autocmd("BufLeave", {
        --     buffer = event.buf,
        --     callback = function(ev)
        --         funcs.doau("LeaveNetRw", {
        --             netrw_win = win,
        --         })
        --     end,
        -- })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CloseNetrw",
    callback = function(event)
        netrw_funcs.close_netrw_debounce(event.data)
    end,
})
