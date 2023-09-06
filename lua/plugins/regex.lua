return {
    "bennypowers/nvim-regexplainer",
    opts = {
        mappings = {
            toggle = "gR",
            show = "gS",
            hide = "gH",
            show_split = "gP",
            show_popup = "gU",
        },
    },
    dependencies = {
        "nvim-treesitter",
        "MunifTanjim/nui.nvim",
    },
    keys = { "gR", "gS", "gH", "gP", "gU" },
}
