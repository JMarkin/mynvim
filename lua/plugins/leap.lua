require("leap").setup({
    highlight_unlabeled = true,
    case_sensitive = false,
    special_keys = {
        repeat_search = "<tab>",
        next_match = "<tab>",
        prev_match = "<s-tab>",
        next_group = "<tab>",
        prev_group = "<s-tab>",
    },
})

require("leap").set_default_keymaps()
