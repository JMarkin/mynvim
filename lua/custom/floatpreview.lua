local M = {
    buf = nil,
    win = nil,
    path = nil,
}

local function close_float()
    if M.path ~= nil then
        pcall(vim.api.nvim_win_close, M.win, { force = true })
        pcall(vim.api.nvim_buf_delete, M.buf, { force = true })
        M.win = nil
        M.buf = nil
        M.path = nil
    end
end

M.close_float = close_float

local function float_preview(prev_win, path)
    M.path = path
    local buf, win
    buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "unload")

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local opts = {
        style = "minimal",
        relative = "win",
        width = math.ceil(width / 2),
        height = math.ceil(height / 2),
        bufpos = { vim.fn.line(".") - 1, vim.fn.col(".") + 30 },
        border = "rounded",
        focusable = false,
    }

    win = vim.api.nvim_open_win(buf, true, opts)
    -- vim.api.nvim_command("edit " .. path)
    vim.api.nvim_command("term cat " .. vim.fn.shellescape(path))

    local ok, _ = pcall(vim.api.nvim_set_current_win, prev_win)

    if not ok then
        close_float()
    end

    M.win, M.buf = win, buf
end
M.float_preview = float_preview

M.float_close_decorator = function(func)
    return function()
        close_float()
        func()
    end
end
return M
