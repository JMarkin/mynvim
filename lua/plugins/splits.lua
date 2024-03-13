return {
    {
        "mrjones2014/smart-splits.nvim",
        -- enabled = false,
        opts = {
            multiplexer_integration = "tmux",
        },
        keys = {
        -- stylua: ignore start
            { "<C-l>", function(...) require("smart-splits").move_cursor_right(...) end, silent = true, desc = "right",        mode = { "n", "t", "v" }    },
            { "<C-j>", function(...) require("smart-splits").move_cursor_down(...) end,  silent = true, desc = "down",         mode = { "n", "t", "v" },   },
            { "<C-k>", function(...) require("smart-splits").move_cursor_up(...) end,    silent = true, desc = "top",          mode = { "n", "t", "v" },   },
            { "<C-h>", function(...) require("smart-splits").move_cursor_left(...) end,  silent = true, desc = "left",         mode = { "n", "t", "v" },   },
            { "<A-h>", function(...) require("smart-splits").resize_left(...) end,       silent = true, desc = "Resize left",  mode = { "n", "t", "v" },   },
            { "<A-j>", function(...) require("smart-splits").resize_down(...) end,       silent = true, desc = "Resize down",  mode = { "n", "t", "v" },   },
            { "<A-k>", function(...) require("smart-splits").resize_up(...) end,         silent = true, desc = "Resize up",    mode = { "n", "t", "v" },   },
            { "<A-l>", function(...) require("smart-splits").resize_right(...) end,      silent = true, desc = "Resize right", mode = { "n", "t", "v" },   },
            -- stylua: ignore end
        },
    },
    {
        "AndrewRadev/splitjoin.vim",
        event = "VeryLazy",
        init = function()
            vim.g.splitjoin_split_mapping = "gs"
            vim.g.splitjoin_join_mapping = "gj"
        end,
    },
}
