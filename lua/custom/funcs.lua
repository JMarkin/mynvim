local M = {}
M.is_not_mini = function()
    return vim.env.NVIM_MINI == nil
end

return M
