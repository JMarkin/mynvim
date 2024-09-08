local M = {}

local funcs = require("funcs")

local get_payload = function()
    local parse = require("netrw.parse")

    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()

    local row, _ = unpack(vim.api.nvim_win_get_cursor(winid))
    local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)
    return parse.get_node(line[1])
end

M.get_node = function()
    local payload = get_payload()
    if payload.extension ~= nil then
        payload.absolute_path = payload.dir .. "/" .. payload.node
        payload.type = "file"
    end
    return payload
end

local mapcheck_call = function(name)
    local fn = vim.fn.mapcheck(name)
    -- :<C-U>call netrw#LocalBrowseCheck(<SNR>43_NetrwBrowseChgDir(1,<SNR>43_NetrwGetWord()))<CR>
    local call = string.match(fn, ".*call (.*)<[crCR]+>")

    vim.cmd("call " .. call)
end

M.debug = function()
    vim.print(get_payload())
end

-- error
M.create_under_cursor = function()
    local payload = get_payload()
    vim.opt_local.modifiable = true
    if payload.extension == nil then
        mapcheck_call(M.open)
    end
    mapcheck_call("<Plug>NetrwOpenFile")
    vim.opt_local.modifiable = false
end

M.close_netrw_debounce = funcs.debounce_trailing(function(data)
    if not data then
        return
    end
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    local ft = vim.bo[buf].ft
    if ft ~= "netrw" then
        -- print(win, data.netrw_win)
        pcall(vim.api.nvim_win_close, data.netrw_win, false)
    end
end, 200, false)

M.toggle_hidden = "<Plug>NetrwHide_a"
M.close_preview = "<C-w>z"
M.close = ":q<cr>"
M.reload = "<Plug>NetrwRefresh"
M.open = "<Plug>NetrwLocalBrowseCheck"
M.server_edit = "<Plug>NetrwServerEdit"
M.prev = "<Plug>NetrwBrowseUpDir"

M.open_o = ":call <SNR>43_NetrwSplit(3)<CR>"
M.open_v = ":call <SNR>43_NetrwSplit(5)<CR>"

return M
