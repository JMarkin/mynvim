local M = {}

M.rename_win_id = nil

M.show_renamer = function ()
    return M.rename_win_id ~= nil
end

M.rename = function()
    local win_id, _ = require("renamer").rename({})
    M.rename_win_id = win_id
end

M.config = function()
    require("renamer").setup({
        handler = function(resp)
            M.rename_win_id = nil
        end,
    })
end

return M
