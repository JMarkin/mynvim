local M = {}

local is_not_mini = require("custom.funcs").is_not_mini

M.plugin = {
    "danymat/neogen",
    cond = is_not_mini,
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("neogen").setup({
            enabled = true,
            input_after_comment = true,
            snippet_engine = "luasnip",
        })
    end,
    cmd = "Neogen",
    keys = {
        {
            "<leader>lD",
            "<cmd>Neogen<cr>",
            desc = "Lang: generate docs",
        },
    },
}

return M
