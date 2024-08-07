return {
    {
        "yorickpeterse/nvim-window",
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
    {
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<space>bb",
                function()
                    require("snipe").open_buffer_menu()
                end,
                desc = "Open Snipe buffer menu",
            },
        },
        opts = {},
    },
}
