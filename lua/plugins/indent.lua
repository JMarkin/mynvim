vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
--
local is_not_mini = require("funcs").is_not_mini

local highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
}

return {
    "lukas-reineke/indent-blankline.nvim",
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
