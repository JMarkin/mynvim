local M = {}

M.plugin = {
    "kylechui/nvim-surround",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter",
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            dependencies = { "nvim-treesitter" },
        },
    },
    config = function()
        require("nvim-surround").setup({
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "S",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
            },
        })
        vim.cmd.highlight("default link NvimSurroundHighlight IncSearch")
    end,
    keys = {
        "ys",
        "yS",
        "cs",
        "S",
        "gS",
        "ds",
        "<C-g>",
    },
}

return M
