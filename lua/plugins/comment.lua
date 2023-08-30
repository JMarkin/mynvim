local M = {}

local _keys = { "gcc", "gc", "gbc", "gb", "gcO", "gco", "gcA" }
local keys = {}

for k, v in pairs(_keys) do
    keys[k] = { v, mode = { "n", "v" } }
end

M.plugin = {
    "numToStr/Comment.nvim",
    opts = {},
    keys = keys,
}

return M
