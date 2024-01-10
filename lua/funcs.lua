local M = {}

M.is_not_mini = function()
    return vim.env.NVIM_MINI == nil
end

vim.cmd([[
    command! QfUpdate call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0)})'))
]])

vim.api.nvim_create_user_command("QfReplace", function(opts)
    local cmd = string.format("s/%s/%s/c | update | QfUpdate", opts.fargs[1], opts.fargs[2])
    vim.cmd.cdo(cmd)
end, {
    nargs = "*",
    complete = "tag",
})

M.doau = function(pattern, data)
    vim.api.nvim_exec_autocmds("User", {
        pattern = pattern,
        data = data,
    })
end

function M.maxline(path)
    local fd = vim.uv.fs_open(path, "r", 1)
    local stat = vim.uv.fs_fstat(fd)
    local data = vim.uv.fs_read(fd, stat.size, nil)
    vim.uv.fs_close(fd)
    local max = 0

    local lines = vim.split(data, "[\r]?\n")

    for _, line in pairs(lines) do
        if max < #line then
            max = #line
        end
    end
    return max
end

function M.get_visual()
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    if start_pos == nil or end_pos == nil then
        return ""
    end

    local start_row, start_col = start_pos[2], start_pos[3]
    local end_row, end_col = end_pos[2], end_pos[3]

    if end_row < start_row then
        start_row, end_row = end_row, start_row
    end
    if end_col < start_col then
        start_col, end_col = end_col, start_col
    end

    local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

    return table.concat(lines, "\n"), start_row, end_row
end

function M.get_previous_visual()
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")

    if vstart == nil or vend == nil or vend[2] == 0 then
        return ""
    end

    local start_row = vstart[2]
    local end_row = vend[2]
    local select_start_line = start_row

    if select_start_line ~= 0 then
        select_start_line = select_start_line - 1
    end

    local lines = vim.api.nvim_buf_get_lines(0, select_start_line, end_row, true)
    return table.concat(lines, "\n"), start_row, end_row
end

function M.in_visual_mode()
    local modes = {
        Rv = true,
        Rvc = true,
        Rvx = true,
        V = true,
        Vs = true,
        niV = true,
        noV = true,
        nov = true,
        v = true,
        vs = true,
    }
    local current_mode = vim.api.nvim_get_mode()["mode"]
    return modes[current_mode] or false
end

return M
