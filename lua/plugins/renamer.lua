local M = {}

M.rename_win_id = nil

M.rename = function()
    local win_id, _ = require("renamer").rename({
        handler = function()
            M.rename_win_id = nil
        end,
    })
    M.rename_win_id = win_id
end

return M
