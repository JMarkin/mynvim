return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = false,
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = " 󰍟 ", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },

        window = {
            border = "shadow", -- none/single/double/shadow
        },

        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },

        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            i = { "j", "k" },
            v = { "j", "k" },
        },
        plugins = {
            presets = {
                operators = false,
            },
        },
        layout = {
            align = "left", -- align columns left, center or right
        },
    },
    config = function()
        local wk = require("which-key")

        wk.register({
            ["<leader>t"] = { name = "Tabs" },
            ["<leader>l"] = { name = "Lang" },
            ["<leader>g"] = { name = "Git" },
            ["<leader>s"] = { name = "Search" },
            ["<leader>d"] = { name = "Debug" },
            ["<space>b"] = { name = "Buffers" },
            ["<leader>b"] = { name = "Bookmark" },
        })
    end,
}
