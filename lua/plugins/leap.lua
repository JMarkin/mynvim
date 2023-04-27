local M = {}

M.plugin = {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
        require("leap").setup({
            highlight_unlabeled = true,
            case_sensitive = false,
            special_keys = {
                repeat_search = "<tab>",
                next_phase_one_target = "<tab>",
                next_target = "<tab>",
                prev_target = "<s-tab>",
                next_group = "<space>",
                prev_group = "<c-space>",
                multi_accept = "<enter>",
                multi_revert = "<backspace>",
            },
        })
        require("leap").opts.highlight_unlabeled_phase_one_targets = true
        require("leap").add_default_mappings()
        vim.keymap.del({ "x", "o" }, "x")
        vim.keymap.del({ "x", "o" }, "X")
    end,
    event = "BufReadPost",
    keys = { "s", "S" },
}
return M
