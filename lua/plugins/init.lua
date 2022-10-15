vim.cmd([[packadd packer.nvim]])

local packer = require("packer")

packer.init({
    max_jobs = 16,
})

return packer.startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- профилировщик оптимизатор neovim
    use({
        "lewis6991/impatient.nvim",
    })

    -- обноление cursorhold
    use("antoinemadec/FixCursorHold.nvim")

    --- Украшения

    use({
        "mcauley-penney/tidy.nvim",
        config = function()
            require("tidy").setup()
        end,
    })
    use({
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
    })

    use({
        "mvllow/modes.nvim",
        config = function()
            require("modes").setup({
                set_cursor = false,
                colors = {
                    copy = "#f5c359",
                    delete = "#c75c6a",
                    insert = "#78ccc5",
                    visual = "#9745be",
                },
                line_opacity = 0.4,
            })
        end,
        event = "ModeChanged",
    })

    use({
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup({
                max_length = 100000000, -- Maximum length of selection
                silent = false, -- Disable message on successful copy
                trim = true, -- Trim text before copy
            })
        end,
    })

    use({
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                timeout = 500,
                stages = "fade",
                level = vim.log.levels.WARN,
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end,
    })

    use({
        "anuvyklack/windows.nvim",
        requires = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require("windows").setup({
                ignore = {
                    buftype = { "quickfix", "nofile" },
                    filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "Outline" },
                },
            })
        end,
    })

    use({ "rainbowhxch/beacon.nvim" })

    use({
        "nvim-lua/plenary.nvim",
    })

    use({
        "b0o/incline.nvim",
        setup = function()
            vim.opt.laststatus = 3
        end,
        config = function()
            require("plugins.incline")
        end,
    })

    use({
        "declancm/cinnamon.nvim",
        config = function()
            require("cinnamon").setup({
                extra_keymaps = true,
                extended_keymaps = true,
            })
        end,
    })

    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("plugins.dashboard")
        end,
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent")
        end,
    })

    --- вместо ESC просто jj
    use({
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({
                mapping = { "jj", "qq", ":w" },
                clear_empty_lines = true,
            })
        end,
    })

    --- Локальный настройки для папки с помощью .lvimrc с хэшем
    use({
        "klen/nvim-config-local",
        config = function()
            require("config-local").setup({
                -- Default configuration (optional)
                config_files = { ".vimrc.lua", ".vimrc", ".lvimrc" }, -- Config file patterns to load (lua supported)
                hashfile = vim.fn.stdpath("data") .. "/config-local", -- Where the plugin keeps files data
                autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
                commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
                silent = false, -- Disable plugin messages (Config loaded/ignored)
                lookup_parents = true,
            })
        end,
    })

    -- Markdown превью
    use({
        "ellisonleao/glow.nvim",
        cmd = "Glow",
    })

    -- Цвет тема
    use({
        "JMarkin/nvim-highlite",
        config = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme highlite")
        end,
    })

    -- Информационная строка внизу
    use({
        "WhoIsSethDaniel/lualine-lsp-progress",
        event = "BufReadPre",
    })
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        event = "BufReadPre",
        config = function()
            require("plugins.lualine")
        end,
        after = "lualine-lsp-progress",
    })

    -- Файловый менеджер
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        setup = function()
            require("plugins.filetree").setup()
        end,
        config = function()
            require("plugins.filetree").config()
        end,
        cmd = "Neotree",
    })

    -- Подцветка синтаксиа

    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("plugins.treesitter").setup()
        end,
    })

    use({
        "yioneko/nvim-yati",
        after = "nvim-treesitter",
    })

    use({
        "p00f/nvim-ts-rainbow",
        after = "nvim-treesitter",
    })

    use({
        "windwp/nvim-ts-autotag",
        config = function()
            require("plugins.treesitter").callback_after_setup(function()
                require("nvim-ts-autotag").setup()
            end)
        end,
    })
    use({
        "m-demare/hlargs.nvim",
        config = function()
            require("plugins.treesitter").callback_after_setup(function()
                require("hlargs").setup({
                    use_colorpalette = true,
                })
            end)
        end,
    })

    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        after = "nvim-treesitter",
        config = function()
            require("todo-comments").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    })

    -- Доп утился для языков
    use({
        "simrat39/rust-tools.nvim",
    })
    use("https://git.sr.ht/~p00f/clangd_extensions.nvim")
    use("b0o/schemastore.nvim")

    -- LSP
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use({
        "williamboman/mason-lspconfig.nvim",
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                auto_fold = false,
                auto_close = true,
            })
        end,
        cmd = "TroubleToggle",
    })

    if vim.fn.has("nvim-0.8") == 1 then
        use({
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig",
            config = function()
                require("nvim-navic").setup({ highlight = true })
                vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
            end,
        })
    end

    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.nullls").config()
        end,
    })

    use({ "kevinhwang91/nvim-bqf", ft = "qf" })
    use({
        "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        config = function()
            require("pqf").setup()
        end,
    })
    use({
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
    })

    use({
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
    })

    use({
        "filipdutescu/renamer.nvim",
        branch = "master",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("plugins.renamer").config()
        end,
    })

    use({
        "ThePrimeagen/refactoring.nvim",
        config = function()
            require("refactoring").setup({})
        end,
    })

--     use({
--         "kevinhwang91/nvim-ufo",
--         requires = "kevinhwang91/promise-async",
--         event = "BufReadPre",
--         after = "nvim-treesitter",
--         setup = function ()
--            require("plugins.ufo").setup()
--         end
--         config = function()
--             require("plugins.ufo").config()
--         end,
--     })

    --- Автокомлиты

    use({
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "CmdlineEnter" },
        keymap = "/",
    })

    use({
        "lukas-reineke/cmp-under-comparator",
        event = { "VimEnter" },
    })
    use({
        "hrsh7th/nvim-cmp",
        after = { "cmp-under-comparator", "LuaSnip" },
        config = function()
            require("plugins.cmp").config()
        end,
        event = { "InsertEnter", "CmdlineEnter" },
        keymap = "/",
    })
    use({
        "lukas-reineke/cmp-rg",
        after = "nvim-cmp",
    })
    use({
        "hrsh7th/cmp-nvim-lsp",
        after = "nvim-cmp",
    })
    use({
        "quangnguyen30192/cmp-nvim-tags",
        after = "nvim-cmp",
    })
    use({
        "rcarriga/cmp-dap",
        after = "nvim-cmp",
    })
    use({
        "saadparwaiz1/cmp_luasnip",
        after = { "LuaSnip", "nvim-cmp" },
    })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    use({ "petertriho/cmp-git", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" })

    use({
        "JMarkin/gentags.lua",
        config = function()
            require("gentags").setup()
        end,
    })

    -- Табы
    use({
        "Asheq/close-buffers.vim",
    })
    --
    use({
        "mrjones2014/smart-splits.nvim",
    })

    -- Навигация внутри файла по классам и функциям
    use({
        "simrat39/symbols-outline.nvim",
        config = function()
            require("symbols-outline").setup({})
        end,
        cmd = "SymbolsOutline",
    })

    --  Git
    use("kdheepak/lazygit.nvim")
    use({
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gitsigns").setup()
        end,
    })
    use({
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
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
                        disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
                    },
                    file_history = {
                        -- Config for changed files in file history views.
                        layout = "diff2_horizontal",
                    },
                },
            })
        end,
    })

    -- Colorize
    use({
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    RGB = true, -- #RGB hex codes
                    RRGGBB = true, -- #RRGGBB hex codes
                    names = true, -- "Name" codes like Blue or blue
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    rgb_fn = true, -- CSS rgb() and rgba() functions
                    hsl_fn = true, -- CSS hsl() and hsla() functions
                    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = "background", -- Set the display mode.
                    virtualtext = "■",
                },
            })
        end,
        event = "BufReadPre",
    })

    -- Комментирование
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
        event = "BufReadPre",
    })
    use({
        "s1n7ax/nvim-comment-frame",
        after = {
            "nvim-treesitter",
        },
        config = function()
            require("nvim-comment-frame").setup()
        end,
        event = "BufReadPre",
    })

    -- EasyMotion
    use({
        "ggandor/leap.nvim",
        requires = { "tpope/vim-repeat" },
        config = function()
            require("plugins.leap")
        end,
        event = "BufReadPre",
    })

    -- Дебагер
    use({
        "mfussenegger/nvim-dap",
        keymap = "<leader>d",
    })
    use({
        "rcarriga/nvim-dap-ui",
        after = { "nvim-dap" },
        config = function()
            require("dapui").setup()
        end,
    })
    use({
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
        after = { "nvim-treesitter", "nvim-dap" },
    })
    use({ "ofirgall/goto-breakpoints.nvim", after = "nvim-dap" })
    -- use({
    --     "Weissle/persistent-breakpoints.nvim",
    --     after = "nvim-dap",
    --     config = function()
    --         require("persistent-breakpoints").setup({})
    --         --- загрузка брекпоинтов
    --         vim.api.nvim_create_autocmd(
    --             { "BufReadPost" },
    --             { callback = require("persistent-breakpoints.api").load_breakpoints }
    --         )
    --     end,
    -- })

    -- editorconfig
    use("gpanders/editorconfig.nvim")

    --- поиски по файлам проверкам и т.п. fzf вобщем
    use({
        "ibhagwan/fzf-lua",
        requires = {
            "lotabout/skim",
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("plugins.fzflua").setup()
        end,
        event = "VimEnter",
    })

    --- Генераци докстрингов и т.п.
    use({
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
    })

    -- превью строчки при :%d
    use({
        "nacro90/numb.nvim",
        config = function()
            require("numb").setup()
        end,
        event = "CmdlineEnter",
    })

    --nginx
    use({
        "chr4/nginx.vim",
        ft = { "nginx" },
    })

    use({
        "chr4/sslsecure.vim",
        ft = { "nginx" },
    })
    -- засейчка neovim
    use({
        "dstein64/vim-startuptime",
        cmd = { "StartupTime" },
    })

    -- sudo
    use({
        "lambdalisue/suda.vim",
        cmd = { "SudaRead", "SudaWrite" },
    })

    -- bookmark
    use({
        "MattesGroeger/vim-bookmarks",
        after = { "mapx" },
        setup = function()
            require("plugins.bookmark").setup()
        end,
        keys = "<leader>b",
    })

    -- терминал
    use({
        "oberblastmeister/termwrapper.nvim",
        config = function()
            require("termwrapper").setup({
                -- these are all of the defaults
                open_autoinsert = false, -- autoinsert when opening
                toggle_autoinsert = true, -- autoinsert when toggling
                autoclose = true, -- autoclose, (no [Process exited 0])
                winenter_autoinsert = false, -- autoinsert when entering the window
                default_window_command = "belowright 13split", -- the default window command to run when none is specified,
                -- opens a window in the bottom
                open_new_toggle = true, -- open a new terminal if the toggle target does not exist
                log = 1, -- 1 = warning, 2 = info, 3 = debug
            })
        end,
    })

    -- Классная штука по отображению shortcut
    use({
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
        event = "VimEnter",
    })

    -- Удобный способ задания shortcut с интеграцией в which-key
    use({
        "b0o/mapx.nvim",
        as = "mapx",
        after = { "which-key.nvim" },
        config = function()
            local m = require("mapx").setup({ global = "force", whichkey = true })
            require("settings.keymap")(m)
        end,
    })

    -- курсор следует за shift
    use({
        "gbprod/stay-in-place.nvim",
        config = function()
            require("stay-in-place").setup({
                set_keymaps = true,
                preserve_visual_selection = true,
            })
        end,
        event = "BufReadPre",
    })

    -- yaml
    use({
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        after = {
            "nvim-treesitter",
        },
    })
    -- databases
    use({
        "tpope/vim-dadbod",
        cmd = { "DB" },
    })
    use({
        "kristijanhusak/vim-dadbod-ui",
        requires = "tpope/vim-dadbod",
        setup = function()
            vim.g.db_ui_env_variable_url = "DATABASE_URL"
            vim.g.db_ui_env_variable_name = "DATABASE_NAME"
            vim.g.db_ui_dotenv_variable_prefix = "DB_"
            vim.g.db_ui_execute_on_save = 0
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        cmd = { "DB", "DBUI", "DBUIToggle", "DBUIFindBUffer", "DBUIRenameBuffer" },
    })
    use({
        "kristijanhusak/vim-dadbod-completion",
        after = { "vim-dadbod-ui", "nvim-cmp" },
    })

    -- uncompiler
    use({
        "p00f/godbolt.nvim",
        config = function()
            require("godbolt").setup()
        end,
        cmd = { "Godbolt", "GodboltCompiler" },
    })

    use({
        "https://gitlab.com/yorickpeterse/nvim-window",
    })

    -- tests
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
        },
    })
    use({
        "nvim-neotest/neotest-python",
        after = "neotest",
    })
    use({
        "rouge8/neotest-rust",
        after = "neotest",
    })
end)
