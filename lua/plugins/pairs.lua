return {
    "windwp/nvim-autopairs",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        fast_wrap = {
            map = "<C-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            manual_position = true,
            highlight = "Search",
            highlight_grey = "Comment",
        },
    },
}
