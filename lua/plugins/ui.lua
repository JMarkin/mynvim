return {
    -- Better `vim.notify()`
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 1000,
            stages = "static",
            level = vim.log.levels.INFO,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        config = function(args)
            args.opts.background_colour = vim.g.notify_background_color
            require("notify").setup(args.opts)
            vim.notify = require("notify")
        end,
        event = "VeryLazy",
        lazy = true,
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        config = function()
            require("dressing").setup({
                input = {
                    winhighlight = vim.g.dressing_winhighlight,
                    insert_only = false,
                    override = function(conf)
                        conf.col = -1
                        conf.row = 0
                        return conf
                    end,
                },
            })
        end,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "mvllow/modes.nvim",
        event = { "VeryLazy", "ModeChanged" },
        opts = {
            line_opacity = 0.25,
            set_cursor = false,
        },
    },

    {
        "ibhagwan/smartyank.nvim",
        enabled = true,
        event = "VeryLazy",
        opts = {
            highlight = {
                enabled = false, -- highlight yanked text
                higroup = "ModesCopy", -- highlight group of yanked text
                timeout = 100, -- timeout for clearing the highlight
            },
        },
        dependencies = {
            "mvllow/modes.nvim",
        },
    },

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
        event = { "VeryLazy", "FileReadPre", "BufReadPre" },
    },
    {
        "rainbowhxch/beacon.nvim",
        cond = function()
            return not vim.g.neovide
        end,
        opts = {
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
        },
        event = { "VeryLazy", "BufAdd" },
    },
    {
        "tzachar/local-highlight.nvim",
        event = { "VeryLazy", "FileReadPre", "BufReadPre" },
        opts = {
            insert_mode = true,
        },
    },
    {
        "nvimdev/hlsearch.nvim",
        event = { "VeryLazy", "FileReadPre", "BufReadPre" },
        config = function()
            require("hlsearch").setup()
        end,
    },
}
