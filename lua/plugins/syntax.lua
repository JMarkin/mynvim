return {
    {
        "sheerun/vim-polyglot",
        event = { "BufReadPre", "FileReadPre" },
        init = function()
            vim.cmd([[
                syntax on
            ]])
            vim.g.polyglot_disabled = { "ftdetect" }
        end,
    },
}
