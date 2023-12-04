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
    local fd = vim.loop.fs_open(path, "r", 1)
    local stat = vim.loop.fs_fstat(fd)
    local data = vim.loop.fs_read(fd, stat.size, nil)
    vim.loop.fs_close(fd)
    local max = 0

    local lines = vim.split(data, "[\r]?\n")

    for _, line in pairs(lines) do
        if max < #line then
            max = #line
        end
    end
    return max
end

return M
