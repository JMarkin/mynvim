local M = {}

M.setup = function()
    vim.opt.list = false
    -- vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("multispace:¦   ")
    vim.opt.listchars:append("eol:↴")

        --Enable alignment
    vim.g.neoformat_basic_format_align = 1
    --Enable tab to spaces conversion
    vim.g.neoformat_basic_format_retab = 1
    --Enable trimmming of trailing whitespace
    vim.g.neoformat_basic_format_trim = 1
    vim.g.neoformat_run_all_formatters = 1

end

return M
