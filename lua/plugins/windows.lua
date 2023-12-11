return {
    {
        "anuvyklack/windows.nvim",
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
                buftype = { "quickfix" },
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "blame", "toggleterm" },
            },
            animation = {
                enable = true,
                duration = 300,
                fps = 30,
                easing = "in_out_sine",
            },
        },
        event = "VeryLazy",
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
