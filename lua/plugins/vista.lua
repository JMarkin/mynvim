return {
    "liuchengxu/vista.vim",
    dependencies = {
        {
            "lotabout/skim",
            build = "cargo install skim",
        },
    },
    cmd = {"Vista"},
    keys = {"<space>t"},
    config = function()
        vim.keymap.set("n", "<space>t", ":Vista ctags<cr>", {desc="Tagbar"})
    end
}
