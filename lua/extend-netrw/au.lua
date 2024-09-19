local groupid = vim.api.nvim_create_augroup
local funcs = require("funcs")
local netrw_funcs = require("extend-netrw.funcs")
local float = require("extend-netrw.float-preview")
local keymap = require("extend-netrw.keymap")

local NETRW_WINDS = {}

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
        -- NETRW_WINDS[win] = 1
        --
        -- vim.api.nvim_create_autocmd("BufEnter", {
        --     pattern = "*",
        --     once = true,
        --     callback = function(ev)
        --         local ft = vim.bo[ev.buf].ft
        --         local cur_win = vim.api.nvim_get_current_win()
        --         if ft ~= "netrw" and vim.b[ev.buf]._float_preview == nil then
        --             if NETRW_WINDS[cur_win] == 1 then
        --                 NETRW_WINDS[cur_win] = nil
        --             end
        --
        --             for rwin, _ in pairs(NETRW_WINDS) do
        --                 print("try win_close", rwin)
        --                 -- pcall(vim.api.nvim_win_close, rwin, false)
        --             end
        --             NETRW_WINDS = {}
        --         end
        --     end,
        -- })
    end,
})
