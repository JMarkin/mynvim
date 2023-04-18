local is_not_mini = require("custom.funcs").is_not_mini

require("lazy").setup({

    -- обноление cursorhold
    "antoinemadec/FixCursorHold.nvim",

    {
        "romainl/vim-cool",
        enabled = false,
    },

    --- Украшения
    "nvim-tree/nvim-web-devicons",
    {
        "stevearc/dressing.nvim",
        -- opts = {
        --     input = {
        --         insert_only = false,
        --         override = function(conf)
        --             conf.col = -1
        --             conf.row = 0
        --             return conf
        --         end,
        --     },
        -- },
    },

    {
        "ibhagwan/smartyank.nvim",
        opts = {
            highlight = {
                enabled = true, -- highlight yanked text
                higroup = "ModesCopy", -- highlight group of yanked text
                timeout = 100, -- timeout for clearing the highlight
            },
        },
        event = "BufReadPost",
    },

    {
        "rcarriga/nvim-notify",
        -- lazy = false,
        -- priority = 1000,
        -- opts = {
        --     max_width = 80,
        --     timeout = 1000,
        --     stages = "static",
        --     level = vim.log.levels.INFO,
        --     background_colour = "#000000",
        -- },
    },
    -- командная строчка
    require("plugins.noice").plugin,
    require("plugins.wilder").plugin,

    require("plugins.tabline").plugin,
    require("plugins.incline").plugin,
    require("plugins.dashboard").plugin,
    require("plugins.indent").plugin,
    -- вместо ESC просто jj
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        opts = {
            mapping = { "jj", "qq", "jk" },
            clear_empty_lines = true,
            keys = "<Esc>",
        },
    },

    --- Локальный настройки для папки с помощью .lvimrc с хэшем
    {
        "klen/nvim-config-local",
        opts = {
            -- Default configuration (optional)
            config_files = { ".vimrc.lua", ".vimrc" }, -- Config file patterns to load (lua supported)
            hashfile = vim.fn.stdpath("data") .. "/local", -- Where the plugin keeps files data
            autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
            commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
            silent = true, -- Disable plugin messages (Config loaded/ignored)
            lookup_parents = true,
        },
    },

    -- Markdown превью
    {
        "ellisonleao/glow.nvim",
        cond = is_not_mini,
        config = true,
        cmd = "Glow",
    },

    -- Цвет тема
    {
        "Iron-E/nvim-highlite",
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            require("colorscheme.highlite")
        end,
    },
    {
        "olimorris/onedarkpro.nvim",
        enabled = false,
        lazy = false,
        priority = 1000, -- Ensure it loads first
        config = function()
            require("colorscheme.onedark")
        end,
    },
    {
        "ofirgall/ofirkai.nvim",
        enabled = true,
        lazy = false,
        priority = 1000, -- Ensure it loads first
        dependencies = {
            {
                "rcarriga/nvim-notify",
            },
            {
                "stevearc/dressing.nvim",
            },
        },
        config = function()
            require("ofirkai").setup({})
            -- Requires `WhiteBorder` to show the title.
            require("dressing").setup({
                input = {
                    win_options = {
                        winhighlight = require("ofirkai.plugins.dressing").winhighlight,
                    },
                    insert_only = false,
                    override = function(conf)
                        conf.col = -1
                        conf.row = 0
                        return conf
                    end,
                },
            })
            require("notify").setup({
                background_colour = require("ofirkai").scheme.ui_bg,
                max_width = 80,
                timeout = 1000,
                stages = "static",
                level = vim.log.levels.INFO,
            })
        end,
    },

    -- Информационная строка внизу
    require("plugins.lualine").plugin,

    -- Файловый менеджер

    require("plugins.nvimtree").plugin,
    require("plugins.ranger").plugin,

    -- Подцветка синтаксиа

    { "pearofducks/ansible-vim", ft = "yaml.ansible" },
    { "mityu/vim-applescript", ft = "applescript" },
    { "isobit/vim-caddyfile", ft = "caddyfile" },
    { "chrisbra/csv.vim", ft = "csv" },
    { "tikhomirov/vim-glsl", ft = "glsl" },
    { "jparise/vim-graphql", ft = "graphql" },
    { "CH-DanReif/haproxy.vim", ft = "haproxy" },
    { "towolf/vim-helm", ft = "helm" },
    { "sophacles/vim-bundle-mako", ft = "mako" },
    { "chr4/nginx.vim", ft = "nginx" },
    { "marshallward/vim-restructuredtext", ft = "rst" },
    { "vim-scripts/svg.vim", ft = "svg" },
    { "wgwoods/vim-systemd-syntax", ft = "systemd" },
    { "amadeus/vim-xml", ft = "xml" },
    { "MTDL9/vim-log-highlighting", ft = "log" },

    require("plugins.treesitter").plugin,
    {
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
        opts = {},
    },

    {
        "Wansmer/treesj",
        keys = {
            "<space>m",
            "<space>j",
            "<space>s",
        },
        dependencies = { "nvim-treesitter" },
        opts = {},
    },
    require("plugins.todos").plugin,
    {
        "mvllow/modes.nvim",
        opts = {
            line_opacity = 0.25,
            set_cursor = false,
        },
        event = "BufReadPost",
    },

    -- Доп утился для языков
    {
        "simrat39/rust-tools.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    {
        name = "clangd_extenstions",
        url = "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    {
        "b0o/schemastore.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    {
        "ranelpadon/python-copy-reference.vim",
        cond = is_not_mini,
        ft = { "python" },
        config = function()
            vim.keymap.set("n", "<leader>lcd", ":PythonCopyReferenceDotted<CR>")
            vim.keymap.set("n", "<leader>lcp", ":PythonCopyReferencePytest<CR>")
        end,
    },
    -- LSP

    {
        "williamboman/mason.nvim",
        cond = is_not_mini,
        dependencies = {
            {
                "neovim/nvim-lspconfig",
            },
            {
                "williamboman/mason-lspconfig.nvim",
            },
            {
                "glepnir/lspsaga.nvim",
                dependencies = { "nvim-tree/nvim-web-devicons" },
            },
        },
        config = function()
            require("settings.lang").config()
        end,
        event = "BufReadPre *.*",
        ft = { "dockerfile" },
    },

    {
        "folke/trouble.nvim",
        lazy = true,
        cond = is_not_mini,
        opts = {
            auto_fold = false,
            auto_close = false,
            auto_preview = false,
        },
        cmd = "TroubleToggle",
    },

    require("plugins.nullls").plugin,

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = {
            "nvim-treesitter",
            {
                name = "pqf",
                url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
                config = true,
            },
        },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
        },
    },
    require("plugins.ufo").plugin,
    -- Автокомлиты
    require("plugins.cmp").plugin,
    {
        "JMarkin/gentags.lua",
        lazy = true,
        cond = vim.fn.executable("ctags") == 1,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
    },
    require("plugins.buffers").plugin,
    require("plugins.splits").plugin,

    --  Git
    require("plugins.gitsign").plugin,
    require("plugins.diffview").plugin,
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
        event = "BufReadPre",
    },
    -- Комментирование
    {
        "numToStr/Comment.nvim",
        opts = {},
        event = "BufReadPost",
    },
    -- EasyMotion
    require("plugins.leap").plugin,
    {
        "ggandor/flit.nvim",
        dependencies = { "ggandor/leap.nvim" },
        opts = {},
        keys = { "f", "F", "t", "T" },
    },
    -- Дебагер
    {
        "rcarriga/nvim-dap-ui",
        cond = is_not_mini,
        dependencies = {
            {
                "mfussenegger/nvim-dap",
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
                dependencies = "nvim-treesitter",
            },
            "ofirgall/goto-breakpoints.nvim",
        },
        opts = {},
        keys = "<leader>d",
    },

    --- поиски по файлам проверкам и т.п. fzf вобщем
    {
        "ibhagwan/fzf-lua",
        lazy = true,
        event = "BufReadPre",
        dependencies = {
            "lotabout/skim",
        },
        config = function()
            require("plugins.fzflua")
        end,
        keys = "<leader>s",
        cmd = "FzfLua",
    },
    --- Генераци докстрингов и т.п.
    {
        "danymat/neogen",
        cond = is_not_mini,
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("plugins.neogen")
        end,
        cmd = "Neogen",
    },
    --nginx
    {
        "chr4/sslsecure.vim",
        ft = { "nginx" },
    },
    -- засейчка neovim
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
    require("plugins.bookmark").plugin,
    -- Классная штука по отображению shortcut
    require("plugins.whichkey").plugin,
    -- курсор следует за shift
    {
        "gbprod/stay-in-place.nvim",
        opts = {
            set_keymaps = true,
            preserve_visual_selection = true,
        },
        event = "ModeChanged",
    },
    -- yaml
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter",
        },
    },
    -- databases
    {
        "kristijanhusak/vim-dadbod-ui",
        enabled = true,
        cond = is_not_mini,
        dependencies = {
            "tpope/vim-dadbod",
            {
                "kristijanhusak/vim-dadbod-completion",
                dependencies = "nvim-cmp",
            },
        },
        init = function()
            vim.g.db_ui_execute_on_save = 0
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        ft = { "sql", "mssql", "plsql" },
    },
    {
        "vim-scripts/dbext.vim",
        enabled = false,
        ft = { "sql", "mssql", "plsql" },
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
        name = "nvim-window",
        url = "https://gitlab.com/yorickpeterse/nvim-window",
        event = "BufAdd",
        config = function()
            require("plugins.windows")
        end,
    },
    -- tests
    {
        "nvim-neotest/neotest",
        cond = is_not_mini,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "rouge8/neotest-rust",
        },
        config = function()
            require("plugins.tests")
        end,
        ft = { "python", "rust" },
    },
    -- trim
    {
        "zakharykaplan/nvim-retrail",
        config = function()
            require("retrail").setup()
        end,
    },
    {
        "nvim-zh/colorful-winsep.nvim",
        config = function()
            require("colorful-winsep").setup()
        end,
        event = "BufAdd",
    },
    {
        "rainbowhxch/beacon.nvim",
        event = "BufReadPost",
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
        event = "BufReadPost",
    },
    require("plugins.term").plugin,
    {
        "altermo/npairs-integrate-upair",
        dependencies = { "windwp/nvim-autopairs", "altermo/ultimate-autopair.nvim" },
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("npairs-int-upair").setup({ map = "u" })
        end,
    },
    {
        "cpea2506/relative-toggle.nvim",
        config = function()
            require("relative-toggle").setup({
                pattern = "*",
                events = {
                    on = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
                    off = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
                },
            })
        end,
        event = "BufEnter",
    },
    {
        "ahmedkhalf/project.nvim",
        enabled = false,
        event = "VimEnter",
        config = function()
            require("plugins.project").setup()
        end,
    },
    {
        "wikitopian/hardmode",
        enabled = false,
        init = function()
            vim.g.HardMode_level = "wannabe"
            vim.g.HardMode_hardmodeMsg = "Don''t use this!"

            vim.api.nvim_create_autocmd({ "VimEnter", "BufNewFile", "BufReadPost" }, {
                pattern = "*",
                command = "call HardMode()",
                desc = "HARD MODE",
            })
        end,
        event = { "VimEnter", "BufNewFile", "BufReadPost" },
    },
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        enabled = false,
    },
})
