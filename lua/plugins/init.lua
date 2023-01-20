local is_not_mini = function()
    return vim.env.NVIM_MINI == nil
end

require("lazy").setup({

    -- обноление cursorhold
    "antoinemadec/FixCursorHold.nvim",

    "romainl/vim-cool",

    --- Украшения
    "nvim-tree/nvim-web-devicons",
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({
                input = {
                    override = function(conf)
                        conf.col = -1
                        conf.row = 0
                        return conf
                    end,
                },
            })
        end,
    },

    {
        "mvllow/modes.nvim",
        config = function()
            require("modes").setup({
                set_cursor = false,
                line_opacity = 0.4,
            })
        end,
        event = "ModeChanged",
    },

    {
        "ibhagwan/smartyank.nvim",
        config = function()
            require("smartyank").setup({
                highlight = {
                    enabled = true, -- highlight yanked text
                    higroup = "ModesCopy", -- highlight group of yanked text
                    timeout = 100, -- timeout for clearing the highlight
                },
            })
        end,
    },

    {
        "rcarriga/nvim-notify",
        lazy = false,
        priority = 1000,
        config = function()
            require("notify").setup({
                timeout = 500,
                stages = "fade",
                level = vim.log.levels.INFO,
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end,
    },

    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = true,
                        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                        -- See the section on formatting for more details on how to customize.
                        --- @type NoiceFormat|string
                        format = "lsp_progress",
                        --- @type NoiceFormat|string
                        format_done = "lsp_progress_done",
                        throttle = 1000 / 30, -- frequency to update lsp progress message
                        view = "mini",
                    },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        keys = "/",
    },
    {
        "anuvyklack/windows.nvim",
        enabled = false,
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        config = function()
            vim.opt.winwidth = 10
            vim.opt.winminwidth = 5
            vim.opt.equalalways = false
            require("windows").setup({
                autowidth = {
                    winwidth = 15,
                },
                ignore = {
                    buftype = { "netrw", "quickfix", "nofile" },
                    filetype = { "netrw", "NvimTree", "neo-tree", "undotree", "gundo", "Outline" },
                },
            })
        end,
        event = "BufAdd",
    },
    {
        "nanozuki/tabby.nvim",
        config = function()
            require("plugins.tabline")
        end,
        event = "TabNew",
    },

    {
        "b0o/incline.nvim",
        init = function()
            vim.opt.laststatus = 3
        end,
        config = function()
            require("plugins.incline")
        end,
        event = "BufReadPost",
    },

    {
        "declancm/cinnamon.nvim",
        config = function()
            require("cinnamon").setup({
                default_keymaps = false,
                extra_keymaps = false,
                extended_keymaps = false,
            })
        end,
    },

    {
        "goolord/alpha-nvim",
        dependencies = {
            {
                "MaximilianLloyd/ascii.nvim",
                dependencies = { "MunifTanjim/nui.nvim" },
            },
        },
        config = function()
            require("plugins.dashboard")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        cond = is_not_mini,
        config = function()
            require("plugins.indent")
        end,
        event = "BufReadPost",
    },

    -- вместо ESC просто jj
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({
                mapping = { "jj", "qq" },
                clear_empty_lines = true,
            })
        end,
    },

    --- Локальный настройки для папки с помощью .lvimrc с хэшем
    {
        "klen/nvim-config-local",
        config = function()
            require("config-local").setup({
                -- Default configuration (optional)
                config_files = { ".vimrc.lua", ".vimrc" }, -- Config file patterns to load (lua supported)
                hashfile = vim.fn.stdpath("data") .. "/local", -- Where the plugin keeps files data
                autocommands_create = false, -- Create autocommands (VimEnter, DirectoryChanged)
                commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
                silent = false, -- Disable plugin messages (Config loaded/ignored)
                lookup_parents = true,
            })
        end,
    },

    -- Markdown превью
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        cond = is_not_mini,
    },

    -- Цвет тема
    {
        "JMarkin/nvim-highlite",
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme highlite")
        end,
    },

    -- Информационная строка внизу
    {
        "nvim-lualine/lualine.nvim",
        event = "BufReadPre",
        config = function()
            require("plugins.lualine")
        end,
    },

    -- Файловый менеджер
    {
        "prichrd/netrw.nvim",
        config = function()
            require("plugins.netrw")
        end,
    },

    -- Подцветка синтаксиа

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = true,
        dependencies = {
            "windwp/nvim-ts-autotag",
            "m-demare/hlargs.nvim",
            "yioneko/nvim-yati",
            {
                name = "nvim-ts-rainbow",
                url = "https://github.com/mrjones2014/nvim-ts-rainbow",
            },
            "nvim-treesitter/nvim-treesitter-refactor",
            {
                "andymass/vim-matchup",
                init = function()
                    vim.g.matchup_transmute_enabled = 1
                    vim.g.matchup_delim_noskips = 1
                    vim.g.matchup_matchparen_deferred = 1
                    vim.g.matchup_matchparen_hi_surround_always = 1
                end,
            },
        },
        config = function()
            require("plugins.treesitter").setup()
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter" },
        config = function()
            require("todo-comments").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
        cond = is_not_mini,
        event = "BufReadPost",
    },

    -- Доп утился для языков
    {
        "simrat39/rust-tools.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    {
        "someone-stole-my-name/yaml-companion.nvim",
        cond = is_not_mini,
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
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
    },
    {
        "PatschD/zippy.nvim",
        config = function()
            require("plugins.zippy")
        end,
        cond = is_not_mini,
        ft = { "python", "javascript", "vue" },
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
                "SmiteshP/nvim-navic",
                config = function()
                    require("nvim-navic").setup({ highlight = true })
                    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
                end,
            },
        },
        config = function()
            require("settings.lang").config()
        end,
        event = "BufReadPre *.*",
    },

    {
        "folke/trouble.nvim",
        lazy = true,
        cond = is_not_mini,
        config = function()
            require("trouble").setup({
                auto_fold = false,
                auto_close = true,
            })
        end,
        cmd = "TroubleToggle",
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        cond = is_not_mini,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.nullls").config()
        end,
    },

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = {
            "nvim-treesitter",
            {
                "junegunn/fzf",
                lazy = true,
            },
            {
                name = "pqf",
                url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
                config = true,
            },
        },
        config = function()
            require("bqf").setup({
                auto_enable = true,
                auto_resize_height = true,
            })
        end,
    },

    {
        "weilbith/nvim-code-action-menu",
        lazy = true,
        cond = is_not_mini,
        cmd = "CodeActionMenu",
    },
    {
        "filipdutescu/renamer.nvim",
        cond = is_not_mini,
        branch = "master",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("plugins.renamer").config()
        end,
        event = "BufReadPost",
    },
    {
        "kevinhwang91/nvim-ufo",
        lazy = true,
        cond = is_not_mini,
        dependencies = { "kevinhwang91/promise-async", "nvim-treesitter" },
        event = "BufReadPost",
        config = function()
            require("plugins.ufo").config()
        end,
    },
    -- Автокомлиты

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "lukas-reineke/cmp-under-comparator",
            "lukas-reineke/cmp-rg",
            "hrsh7th/cmp-nvim-lsp",
            "quangnguyen30192/cmp-nvim-tags",
            "saadparwaiz1/cmp_luasnip",
            "danymat/neogen",
        },
        cond = is_not_mini,
        config = function()
            require("plugins.cmp").config()
        end,
        event = { "InsertEnter" },
    },

    {
        "JMarkin/gentags.lua",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gentags").setup()
        end,
    },
    -- Табы
    {
        "Asheq/close-buffers.vim",
        event = "BufReadPost",
    },
    {
        "mrjones2014/smart-splits.nvim",
    },
    -- Навигация внутри файла по классам и функциям
    {
        "simrat39/symbols-outline.nvim",
        cond = is_not_mini,
        config = function()
            require("plugins.symbols")
        end,
        cmd = "SymbolsOutline",
    },
    --  Git
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gitsigns").setup()
        end,
        event = "BufEnter *.*",
    },
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("diffview").setup({
                view = {
                    -- Configure the layout and behavior of different types of views.
                    -- Available layouts:
                    --  'diff1_plain'
                    --    |'diff2_horizontal'
                    --    |'diff2_vertical'
                    --    |'diff3_horizontal'
                    --    |'diff3_vertical'
                    --    |'diff3_mixed'
                    --    |'diff4_mixed'
                    -- For more info, see ':h diffview-config-view.x.layout'.
                    default = {
                        -- Config for changed files, and staged files in diff views.
                        layout = "diff2_horizontal",
                    },
                    merge_tool = {
                        -- Config for conflicted files in diff views during a merge or rebase.
                        layout = "diff3_mixed",
                        disable_diagnostics = true,
                    },
                    file_history = {
                        -- Config for changed files in file history views.
                        layout = "diff2_horizontal",
                    },
                },
            })
        end,
    },
    -- -- Colorize
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
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
            })
        end,
        event = "BufReadPre",
    },
    -- Комментирование
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
        event = "BufReadPost",
    },
    -- EasyMotion
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("plugins.leap")
        end,
        -- event = "BufReadPost",
        keys = { "s", "S" },
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
                config = function()
                    require("nvim-dap-virtual-text").setup()
                end,
                dependencies = "nvim-treesitter",
            },
            "ofirgall/goto-breakpoints.nvim",
        },
        config = function()
            require("dapui").setup()
        end,
        keys = "<leader>d",
    },

    --     "Weissle/persistent-breakpoints.nvim",
    --     dependencies = "nvim-dap",
    --     config = function()
    --         require("persistent-breakpoints").setup({},    --         --- загрузка брекпоинтов
    --         vim.api.nvim_create_autocmd(
    --             { "BufReadPost" },
    --             { callback = require("persistent-breakpoints.api").load_breakpoints }
    --         )
    --     end,
    -- },

    --- поиски по файлам проверкам и т.п. fzf вобщем
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            "lotabout/skim",
        },
        config = function()
            require("plugins.fzflua").setup()
        end,
        event = "VimEnter",
    },
    {
        "cshuaimin/ssr.nvim",
        cond = is_not_mini,
        -- Calling setup is optional.
        config = function()
            require("ssr").setup({
                min_width = 50,
                min_height = 5,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_all = "<leader>RA",
                },
            })
        end,
        event = "BufReadPost *.*",
    },
    --- Генераци докстрингов и т.п.
    {
        "danymat/neogen",
        cond = is_not_mini,
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("neogen").setup({
                enabled = true,
                input_after_comment = true,
                snippet_engine = "luasnip",
            })
        end,
        event = "BufReadPost *.*",
    },
    -- превью строчки при :%d
    {
        "nacro90/numb.nvim",
        config = function()
            require("numb").setup()
        end,
        event = "CmdlineEnter",
    },
    --nginx
    {
        "chr4/nginx.vim",
        ft = { "nginx" },
    },
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
    {
        "MattesGroeger/vim-bookmarks",
        dependencies = { "mapx" },
        init = function()
            require("plugins.bookmark").setup()
        end,
        keys = "<leader>b",
    },
    -- Классная штука по отображению shortcut
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                plugins = {
                    presets = {
                        operators = false,
                    },
                },
            })
        end,
        lazy = true,
    },
    -- Удобный способ задания shortcut с интеграцией в which-key
    {
        "b0o/mapx.nvim",
        name = "mapx",
        dependencies = { "which-key.nvim" },
        config = function()
            local m = require("mapx").setup({ global = "force", whichkey = true })
            require("settings.keymap")(m)
        end,
    },
    -- курсор следует за shift
    {
        "gbprod/stay-in-place.nvim",
        config = function()
            require("stay-in-place").setup({
                set_keymaps = true,
                preserve_visual_selection = true,
            })
        end,
        event = "BufReadPost",
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
        cond = is_not_mini,
        dependencies = {
            "tpope/vim-dadbod",
            {
                "kristijanhusak/vim-dadbod-completion",
                dependencies = "nvim-cmp",
            },
        },
        init = function()
            vim.g.db_ui_env_variable_url = "DATABASE_URL"
            vim.g.db_ui_env_variable_name = "DATABASE_NAME"
            vim.g.db_ui_dotenv_variable_prefix = "DB_"
            vim.g.db_ui_execute_on_save = 0
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        cmd = { "DB", "DBUI", "DBUIToggle", "DBUIFindBUffer", "DBUIRenameBuffer" },
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
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = vim.g.python_test_runner or "pytest",
                    }),
                },
            })
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
        "emileferreira/nvim-strict",
        config = function()
            require("strict").setup({
                excluded_filetypes = { "text", "markdown", "html", "make" },
                todos = {
                    highlight = false,
                },
                overlong_lines = {
                    length_limit = 120,
                    split_on_save = false,
                },
                deep_nesting = {
                    highlight = false,
                },
            })
        end,
        event = "BufReadPost",
    },
})
