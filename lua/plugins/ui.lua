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
            top_down = true,
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
        "ibhagwan/smartyank.nvim",
        enabled = true,
        event = "ModeChanged",
        opts = {
            highlight = {
                enabled = false, -- highlight yanked text
            },
        },
    },

    {
        "brenoprata10/nvim-highlight-colors",
        enabled = true,
        event = vim.g.post_load_events,
        config = function()
            require("nvim-highlight-colors").turnOn()
        end,
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
        event = { "BufAdd" },
    },
    {
        "tzachar/local-highlight.nvim",
        event = vim.g.post_load_events,
        opts = {
            insert_mode = false,
        },
    },
    {
        "nvimdev/hlsearch.nvim",
        event = { "ModeChanged" },
        config = function()
            require("hlsearch").setup()
        end,
    },
    {
        "nvim-zh/colorful-winsep.nvim",
        config = true,
        event = { "BufAdd" },
    },
    {
        "grapp-dev/nui-components.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        lazy = true,
    },
    {
        "mei28/luminate.nvim",
        enabled = true,
        event = { "VeryLazy" },
        config = function()
            require("luminate").setup({
                duration = 100,
                paste = {
                    enabled = false,
                },
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        event = vim.g.post_load_events,
    },
}
