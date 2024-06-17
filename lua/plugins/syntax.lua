return {
    {
        "sheerun/vim-polyglot",
        event = { "BufReadPre", "FileReadPre" },
        init = function()
            vim.g.polyglot_disabled = { "ftdetect" }
        end,
    },
}
