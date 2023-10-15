-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
--
local is_not_mini = require("funcs").is_not_mini

return {
    "lukas-reineke/indent-blankline.nvim",
    cond = is_not_mini,
    event = "VeryLazy",
    config = function()
        local hooks = require("ibl.hooks")

        require("ibl").setup({ scope = { highlight = vim.g.rainbow_delimiters_highlight } })
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
}
