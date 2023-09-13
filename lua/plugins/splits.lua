return {
    "mrjones2014/smart-splits.nvim",
    enabled = true,
    opts = {
        multiplexer_integration = "tmux",
    },
    keys = {
        {

            "<C-l>",
            function(...)
                require("smart-splits").move_cursor_right(...)
            end,
            silent = true,
            desc = "right",
        },
        {
            "<C-j>",
            function(...)
                require("smart-splits").move_cursor_down(...)
            end,
            silent = true,
            desc = "down",
        },
        {

            "<C-k>",
            function(...)
                require("smart-splits").move_cursor_up(...)
            end,
            silent = true,
            desc = "top",
        },
        {
            "<C-h>",
            function(...)
                require("smart-splits").move_cursor_left(...)
            end,
            silent = true,
            desc = "left",
        },
        {

            "<A-h>",
            function(...)
                require("smart-splits").resize_left(...)
            end,
            silent = true,
            desc = "Resize left",
        },
        {

            "<A-j>",
            function(...)
                require("smart-splits").resize_down(...)
            end,
            silent = true,
            desc = "Resize down",
        },
        {
            "<A-k>",
            function(...)
                require("smart-splits").resize_up(...)
            end,
            silent = true,
            desc = "Resize up",
        },
        {

            "<A-l>",
            function(...)
                require("smart-splits").resize_right(...)
            end,
            silent = true,
            desc = "Resize right",
        },
    },
}
