return {
    "onsails/diaglist.nvim",
    opts = {
        debounce_ms = 150,
    },
    keys = {
        {
            "<space>E",
            function()
                require("diaglist").open_all_diagnostics()
            end,
            desc = "All Diagnostics",
        },
        {
            "<space>e",
            function()
                require("diaglist").open_buffer_diagnostics()
            end,
            desc = "Buffer Diagnostics",
        },
    },
}
