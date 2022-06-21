local M = {}

M.bookmark = function()
    vim.cmd([[
        cgetexpr bm#location_list()
    ]])
    require("fzf-lua").quickfix({})
end

return M
