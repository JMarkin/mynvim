local M = {}
M.is_not_mini = function()
    return vim.env.NVIM_MINI == nil
end

vim.cmd([[
    command! UpdateQF call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0)})'))
]])

vim.api.nvim_create_user_command("Rename", function(opts)
    local cmd = string.format("s/%s/%s/gc | update | UpdateQF", opts.fargs[1], opts.fargs[2])
    vim.cmd.cdo(cmd)
end, {
    nargs = "*",
    complete = "tag",
})

return M
