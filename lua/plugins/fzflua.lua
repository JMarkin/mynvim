require("fzf-lua").setup({
    fzf_bin = "sk",
    async_or_timeout = 3000,
    global_resume = true,
    global_resume_query = true,
    winopts = {
        width = 0.9,
        preview = {
            default = "builtin",
            layout = "vertical",
        },
    },
    keymap = {
        fzf = {
            ["ctrl-a"] = "abort",
            ["ctrl-b"] = "beginning-of-line",
        },
    },
})
