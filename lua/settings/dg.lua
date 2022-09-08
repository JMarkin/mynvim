local M = {
    QF_OPEN = false,
    LL_OPEN = false,
}

local qf_empty = function()
    return vim.tbl_isempty(vim.fn.getqflist())
end

local ll_empty = function()
    return vim.tbl_isempty(vim.fn.getloclist(0))
end

M.sync_all = function()
    vim.diagnostic.setqflist({ open = false, title = "Workspace Diagnostics" })
    vim.diagnostic.setloclist({ open = false, title = "Buffer Diagnostics" })
end

M.sync_buffer = function()
    vim.diagnostic.setloclist({ open = false, title = "Buffer Diagnostics" })
end

M.open_all = function()
    if M.QF_OPEN == false and qf_empty() == false  then
        vim.cmd("lclose")
        vim.cmd("copen")
        M.QF_OPEN = true
        M.LL_OPEN = false
    else
        vim.cmd("cclose")
        M.QF_OPEN = false
    end
end

M.open_buffer = function()
    if M.LL_OPEN == false and ll_empty() == false then
        vim.cmd("cclose")
        vim.cmd("lopen")
        M.LL_OPEN = true
        M.QF_OPEN = false
    else
        vim.cmd("lclose")
        M.LL_OPEN = false
    end
end

return M
