return {
    {
        "anuvyklack/windows.nvim",
        -- dev = true,
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        opts = {
            autowidth = {
                enable = true,
                winwidth = 1.2,
            },
            ignore = {
                buftype = { "quickfix", "nofile" },
                filetype = {
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
                enable = true,
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
