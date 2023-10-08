local is_not_mini = require("funcs").is_not_mini

return {
    "antoinemadec/FixCursorHold.nvim",

    {
        "max397574/better-escape.nvim",
        enabled = false,
        event = "InsertEnter",
        opts = {
            mapping = { "jj", "qq", "jk" },
            clear_empty_lines = true,
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
            },
            {
                "<leader>lcp",
                ":PythonCopyReferencePytest<CR>",
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

    { "yorickpeterse/nvim-pqf", name = "pqf", config = true, ft = "qf" },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
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
            callbacks = {
                pre_open = function(bufnr, winnr, filetype)
                    pcall(require, "tabby")
                end,
            },
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
    {
        "stevearc/profile.nvim",
        keys = "F2",
        config = function()
            local function toggle_profile()
                local prof = require("profile")
                if prof.is_recording() then
                    prof.stop()
                    vim.ui.input(
                        { prompt = "Save profile to:", completion = "file", default = "profile.json" },
                        function(filename)
                            if filename then
                                prof.export(filename)
                                vim.notify(string.format("Wrote %s", filename))
                            end
                        end
                    )
                else
                    prof.start("*")
                end
            end
            vim.keymap.set("", "<F2>", toggle_profile)
        end,
    },
    {
        "theHamsta/nvim_rocks",
        lazy = true,
        dev = true,
        build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    },
}
