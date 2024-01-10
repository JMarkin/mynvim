
return {
    "antoinemadec/FixCursorHold.nvim",

    {
        "max397574/better-escape.nvim",
        enabled = true,
        event = "InsertEnter",
        opts = {
            mapping = { "jj" },
            clear_empty_lines = false,
            keys = "<Esc>",
        },
    },


    { "yorickpeterse/nvim-pqf", name = "pqf", config = true, ft = "qf", event = "VeryLazy" },

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter",
        },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
        },
    },
    --nginx
    {
        "chr4/sslsecure.vim",
        ft = { "nginx" },
    },
    {
        "dstein64/vim-startuptime",
        cmd = { "StartupTime" },
    },
    -- sudo
    {
        "lambdalisue/suda.vim",
        cmd = { "SudaRead", "SudaWrite" },
    },
    {
        "gbprod/stay-in-place.nvim",
        opts = {
            set_keymaps = true,
            preserve_visual_selection = true,
        },
        event = "ModeChanged",
    },

    {
        "farmergreg/vim-lastplace",
        init = function()
            vim.g.lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
            vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
            vim.g.lastplace_open_folds = 1
        end,
    },
}
