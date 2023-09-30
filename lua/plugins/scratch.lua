return {
    {
        "michaelb/sniprun",
        build = "sh install.sh && pip install --user klepto",
        cmd = {
            "SnipRun",
            "SnipReset",
            "SnipClose",
            "SnipInfo",
            "SnipReplMemoryClean",
            "SnipLive",
        },
        lazy = true,
        opts = {
            repl_enable = { "Python3_original", "Lua_nvim" },
            display = { "VirtualTextOk", "VirtualTextErr", "TerminalWithCode" },
            display_options = {
                terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
                terminal_line_number = true, -- whether show line number in terminal window
                terminal_signcolumn = true, -- whether show signcolumn in terminal window
                terminal_width = 45, -- change the terminal display option width
            },
            live_mode_toggle = "enable",
        },
    },
    {
        "LintaoAmons/scratch.nvim",
        lazy = true,
        cmd = {
            "Scratch",
            "ScratchOpen",
            "ScratchWithName",
            "ScratchCheckConfig",
            "ScratchEditConfig",
        },
        keys = {
            { "<space>sc", "<cmd>Scratch<cr>", desc = "Scratch: new" },
            { "<space>ss", "<cmd>ScratchOpen<cr>", desc = "Scratch: open" },
        },
        dependencies = {
            "michaelb/sniprun",
        },
    },
}
