require("lspsaga").setup({
    finder = {
        jump_to = "p",
        edit = { "o", "<CR>" },
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "t",
        quit = { "q", "<ESC>" },
    },
    definition = {
        edit = "<C-c>o",
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "<C-c>t",
        quit = "q",
        close = "<Esc>",
    },
    rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
    },
    callhierarchy = {
        show_detail = false,
        keys = {
            edit = "e",
            vsplit = "<C-v>",
            split = "<C-s>",
            tabe = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u",
        },
    },
    lightbulb = {
        enable = false,
    },
})
