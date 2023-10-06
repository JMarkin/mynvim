vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
--
local is_not_mini = require("funcs").is_not_mini

return {
    "lukas-reineke/indent-blankline.nvim",
    cond = is_not_mini,
    lazy = true,
    opts = {},
}
