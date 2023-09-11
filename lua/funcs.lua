local M = {}

M.is_not_mini = function()
    return vim.env.NVIM_MINI == nil
end

vim.cmd([[
    command! QfUpdate call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0)})'))
]])

vim.api.nvim_create_user_command("QfReplace", function(opts)
    local cmd = string.format("s/%s/%s/gc | update | QfUpdate", opts.fargs[1], opts.fargs[2])
    vim.cmd.cdo(cmd)
end, {
    nargs = "*",
    complete = "tag",
})

return M
