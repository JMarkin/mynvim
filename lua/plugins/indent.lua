local M = {}
vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
--
local is_not_mini = require("custom.funcs").is_not_mini

local highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
}

M.plugin = {
    "lukas-reineke/indent-blankline.nvim",
    branch = "v3",
    cond = is_not_mini,
    config = function()
        require("ibl").setup({
            scope = {
                highlight = highlight,
            },
        })
        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
    event = { "BufReadPost", "FileReadPost" },
}

return M
