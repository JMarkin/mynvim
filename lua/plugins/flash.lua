local M = {}

M.plugin = {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            search = {
                enabled = false,
            },
        },
    },
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Flash Treesitter Search",
        },
    },
}
return M
