return {
    name = "nvim-window",
    url = "https://gitlab.com/yorickpeterse/nvim-window",
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
}
