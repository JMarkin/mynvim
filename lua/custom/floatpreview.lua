local M = {
    buf = nil,
    win = nil,
    path = nil,
    current_line = 1,
    max_line = 999999,
    disabled = false,
}

M.toggle = function()
    if M.buf then
        M.close_float()
    end
    M.disabled = not M.disabled
end

local function close_float()
    if M.path ~= nil then
        pcall(vim.api.nvim_buf_delete, M.buf, { force = true })
        pcall(vim.api.nvim_win_close, M.win, { force = true })
        M.win = nil
        M.buf = nil
        M.path = nil
        M.current_line = 1
        M.max_line = 999999
    end
end

M.close_float = close_float

local function preview()
    if not M.win then
        return
    end
    local cmd = string.format("edit %s", vim.fn.fnameescape(M.path))
    vim.api.nvim_command(cmd)
    M.max_line = vim.fn.line("$")

    local ok, out = pcall(vim.filetype.match, { buf = M.buf, filename = M.path })
    if ok and out then
        cmd = string.format("set filetype=%s", out)
        pcall(vim.api.nvim_command, cmd)
    end
end

local function float_preview(path)
    M.path = path
    M.buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(M.buf, "bufhidden", "unload")
    vim.api.nvim_buf_set_option(M.buf, "readonly", true)

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local prev_height = math.ceil(height / 2)
    local opts = {
        -- style = "minimal",
        relative = "win",
        width = math.ceil(width / 2),
        height = prev_height,
        row = vim.fn.line("."),
        col = vim.fn.winwidth(0) + 1,
        border = "rounded",
        focusable = false,
        noautocmd = true,
    }

    M.win = vim.api.nvim_open_win(M.buf, true, opts)
    preview()
end
M.preview = float_preview

M.close_decorator = function(func)
    return function()
        M.disabled = true
        close_float()
        func()
        M.disabled = false
    end
end

M.scroll = function(line)
    if M.win then
        vim.api.nvim_win_set_cursor(M.win, { line, 0 })
    end
end

M.scroll_down = function()
    if M.buf then
        local next_line = math.min(M.current_line + 20, M.max_line)
        local ok, _ = pcall(M.scroll, next_line)
        if ok then
            M.current_line = next_line
        end
    end
end

M.scroll_up = function()
    if M.buf then
        local next_line = math.max(M.current_line - 20, 1)
        local ok, _ = pcall(M.scroll, next_line)
        if ok then
            M.current_line = next_line
        end
    end
end

M.setup = function(bufnr, get_node)
    vim.keymap.set("n", "<C-e>", M.scroll_up, { buffer = bufnr })
    vim.keymap.set("n", "<C-u>", M.scroll_up, { buffer = bufnr })
    vim.keymap.set("n", "<C-d>", M.scroll_down, { buffer = bufnr })

    local preview_au = "float_preview_au"
    vim.api.nvim_create_augroup(preview_au, { clear = true })
    vim.api.nvim_create_autocmd({ "User CloseNvimFloatPrev" }, {
        pattern = { "*" },
        callback = M.close_float,
        group = preview_au,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
            local buf = vim.api.nvim_get_current_win()
            if M.buf ~= buf then
                M.close_float()
            end
        end,
        group = preview_au,
    })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        buffer = bufnr,
        group = preview_au,
        callback = function()
            if M.disabled then
                return
            end
            local win = vim.api.nvim_get_current_win()
            local node = get_node()
            if not node then
                M.close_float()
            end
            if node.absolute_path == M.path then
                return
            end
            M.close_float()

            if node.type ~= "file" then
                return
            end
            M.preview(node.absolute_path)
            local ok, _ = pcall(vim.api.nvim_set_current_win, win)
            if not ok then
                M.close_float()
            end
        end,
    })
end

return M
