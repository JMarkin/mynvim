return {
    "prichrd/netrw.nvim",
    enabled = false,
    init = function()
        vim.g.netrw_keepdir = 0
        vim.g.netrw_winsize = 15
        vim.g.netrw_banner = 0
        vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
        vim.g.netrw_localcopydircmd = "cp -r"
    end,
    keys = {
        { "<space>f", ":Lexplore<CR>",       desc = "open explore working directory" },
        { "<space>F", ":Lexplore %:p:h<CR>", desc = "open explore current file" },
    },
    opts = {},
}
