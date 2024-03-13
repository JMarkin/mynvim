return {
    {
        "anuvyklack/windows.nvim",
        -- dev = true,
        enabled = false,
        event = "BufAdd",
        dependencies = {
            "anuvyklack/middleclass",
            {
                "anuvyklack/animation.nvim",
                enabled = not vim.g.neovide,
            },
        },
        opts = {
            autowidth = {
                enable = true,
                winwidth = 2,
            },
            ignore = {
                buftype = { "quickfix", "nofile" },
                filetype = {
                    "dbui",
                    "vista_kind",
                    "NvimTree",
                    "neo-tree",
                    "undotree",
                    "gundo",
                    "blame",
                    "toggleterm",
                    "startuptime",
                    "checkhealth",
                    "netrw",
                    "neotest-output",
                    "neotest-output-panel",
                    "neotest-summary",
                    "sagaoutline",
                },
            },
            animation = {
                enable = not vim.g.neovide,
                duration = 300,
                fps = 30,
                easing = "in_out_sine",
            },
        },
    },
    {
        "yorickpeterse/nvim-window",
        event = "BufAdd",
        keys = {
            {
                "<space>w",
                function()
                    require("nvim-window").pick()
                end,
                silent = true,
                desc = "Windows: pick",
                mode = { "n", "v" },
            },
        },
    },
}
