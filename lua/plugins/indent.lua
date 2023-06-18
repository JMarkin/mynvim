local M = {}
vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
--
local is_not_mini = require("custom.funcs").is_not_mini

M.plugin = {
    "lukas-reineke/indent-blankline.nvim",
    cond = is_not_mini,
    opts = {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        -- use_treesitter_scope = true,
        show_first_indent_level = false,
    },
    event = { "BufReadPost", "FileReadPost" },
    cmd = { "IndentBlanklineEnable", "IndentBlanklineDisable" },
}

return M
