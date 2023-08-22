local M = {}

local keys = { "gcc", "gc", "gbc", "gb", "gcO", "gco", "gcA" }

for _, v in pairs(keys) do
    v = { v, mode = { "n", "v" } }
end

M.plugin = {
    "numToStr/Comment.nvim",
    opts = {},
    keys = keys,
}

return M
