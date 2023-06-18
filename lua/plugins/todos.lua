local M = {}

local is_not_mini = require("custom.funcs").is_not_mini

M.plugin = {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter" },
    config = function()
        require("todo-comments").setup({})

        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
        end, { desc = "Previous todo comment" })
    end,
    cond = is_not_mini,
    event = { "BufReadPost", "FileReadPost" },
}

return M
