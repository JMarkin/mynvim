return {
    "junegunn/vim-easy-align",
    keys = {
        { "gl", "<Plug>(EasyAlign)", mode = { "v", "x" }, noremap = false },
        { "gL", "<Plug>(LiveEasyAlign)", mode = { "v", "x" }, noremap = false },
    },
    init = function()
        vim.g.easy_align_delimiters = {
            ["\\"] = {
                pattern = [[\\\+]],
            },
            ["/"] = {
                pattern = [[//\+\|/\*\|\*/]],
                delimiter_align = "c",
                ignore_groups = "!Comment",
            },
        }
    end,
}
