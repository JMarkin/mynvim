local is_not_mini = require("funcs").is_not_mini

return {

    -- обноление cursorhold
    "antoinemadec/FixCursorHold.nvim",

    --- Украшения
    "nvim-tree/nvim-web-devicons",
    {
        "stevearc/dressing.nvim",
        opts = {},
        lazy = true,
        config = function()
            require("dressing").setup({
                input = {
                    winhighlight = require("ofirkai.plugins.dressing").winhighlight,
                    insert_only = false,
                    override = function(conf)
                        conf.col = -1
                        conf.row = 0
                        return conf
                    end,
                },
            })
        end,
        dependencies = {
            "ofirgall/ofirkai.nvim",
        },
    },

    {
        "ibhagwan/smartyank.nvim",
        event = "VeryLazy",
        opts = {
            highlight = {
                enabled = true, -- highlight yanked text
                higroup = "ModesCopy", -- highlight group of yanked text
                timeout = 100, -- timeout for clearing the highlight
            },
        },
        dependencies = {
            "mvllow/modes.nvim",
            opts = {
                line_opacity = 0.25,
                set_cursor = false,
            },
        },
    },

    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        opts = {
            mapping = { "jj", "qq", "jk" },
            clear_empty_lines = true,
            keys = "<Esc>",
        },
    },
    {
        "ofirgall/ofirkai.nvim",
        enabled = true,
        lazy = false,
        priority = 1000, -- Ensure it loads first
        config = function()
            require("ofirkai").setup({})
            vim.api.nvim_set_hl(0, "LspInlayHint", { link = "InlayHints", default = true })
            for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
                vim.api.nvim_set_hl(0, group, {})
            end
            -- local links = {
            --     ["@lsp.type.namespace"] = "@namespace",
            --     ["@lsp.type.type"] = "@type",
            --     ["@lsp.type.class"] = "@type",
            --     ["@lsp.type.enum"] = "@type",
            --     ["@lsp.type.interface"] = "@type",
            --     ["@lsp.type.struct"] = "@structure",
            --     ["@lsp.type.parameter"] = "@parameter",
            --     ["@lsp.type.variable"] = "@variable",
            --     ["@lsp.type.property"] = "@property",
            --     ["@lsp.type.enumMember"] = "@constant",
            --     ["@lsp.type.function"] = "@function",
            --     ["@lsp.type.method"] = "@method",
            --     ["@lsp.type.macro"] = "@macro",
            --     ["@lsp.type.decorator"] = "@function",
            -- }
            -- for newgroup, oldgroup in pairs(links) do
            --     vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
            -- end
        end,
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

    {
        "FabijanZulj/blame.nvim",
        keys = {
            { "<leader>gB", ":ToggleBlame window<cr>", desc = "Git: blame file" },
        },
    },

    -- -- Colorize
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue or blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = true, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                virtualtext = "■",
            },
        },
        event = "VeryLazy",
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
    -- tests
    {
        "nvim-zh/colorful-winsep.nvim",
        config = function()
            require("colorful-winsep").setup()
        end,
        event = "BufAdd",
    },
    {
        "rainbowhxch/beacon.nvim",
        cond = function()
            return not vim.g.neovide
        end,
        config = function()
            require("beacon").setup({
                enable = true,
                size = 40,
                fade = true,
                minimal_jump = 10,
                show_jumps = true,
                focus_gained = true,
                shrink = true,
                timeout = 500,
                ignore_buffers = {},
                ignore_filetypes = {},
            })
        end,
        event = { "BufReadPost", "FileReadPost" },
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
}
