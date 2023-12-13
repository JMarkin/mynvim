local is_not_mini = require("funcs").is_not_mini

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

    { "simrat39/rust-tools.nvim", cond = is_not_mini, lazy = true },
    {
        name = "clangd_extenstions",
        url = "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    { "b0o/schemastore.nvim", cond = is_not_mini, lazy = true },
    {
        "ranelpadon/python-copy-reference.vim",
        cond = is_not_mini,
        ft = { "python" },
        keys = {
            {
                "<leader>lcd",
                ":PythonCopyReferenceDotted<CR>",
                desc = "Copy as: ReferenceDotted",
            },
            {
                "<leader>lcp",
                ":PythonCopyReferencePytest<CR>",
                desc = "Copy as: ReferencePytest",
            },
        },
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter",
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
    -- bookmark
    {
        "gbprod/stay-in-place.nvim",
        opts = {
            set_keymaps = true,
            preserve_visual_selection = true,
        },
        event = "ModeChanged",
    },
    -- uncompiler
    {
        "p00f/godbolt.nvim",
        config = function()
            require("godbolt").setup()
        end,
        cmd = { "Godbolt", "GodboltCompiler" },
    },

    {
        "willothy/flatten.nvim",
        config = true,
        opts = {
            window = {
                open = "tab",
            },
        },
        lazy = false,
        priority = 1001,
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
