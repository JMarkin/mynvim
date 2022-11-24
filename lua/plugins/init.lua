local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")

packer.init({
    max_jobs = 16,
})

local is_not_mini = function ()
    return vim.env.NVIM_MINI == nil
end

return packer.startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- профилировщик оптимизатор neovim
    use({
        "lewis6991/impatient.nvim",
    })

    -- обноление cursorhold
    use("antoinemadec/FixCursorHold.nvim")

    use("romainl/vim-cool")

    --- Украшения
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
        "MunifTanjim/nui.nvim",
    })

    use({
        "mvllow/modes.nvim",
        config = function()
            require("modes").setup({
                set_cursor=false,
                line_opacity = 0.4,
            })
        end,
        event = "ModeChanged",
    })

    use({
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
        "folke/noice.nvim",
        disable = true,
        config = function()
            require("plugins.noice")
        end,
        requires = {
            "rcarriga/nvim-notify",
        },
        after = { "nvim-notify", "nvim-cmp" },
        event = { "CmdlineEnter" },
        keymap = "/",
        cond = is_not_mini,
    })

    use({
        "anuvyklack/windows.nvim",
        requires = {
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
                    buftype = { "quickfix", "nofile", },
                    filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "Outline" },
                },
            })
        end,
    })
    use({
        "nanozuki/tabby.nvim",
        config = function()
            require("plugins.tabline")
        end,
        event = "BufEnter",
    })

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
                default_keymaps = false,
                extra_keymaps = false,
                extended_keymaps = false,
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
        cond = is_not_mini,
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
                hashfile = vim.fn.stdpath("data") .. "/local", -- Where the plugin keeps files data
                autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
                commands_create = false, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
                silent = false, -- Disable plugin messages (Config loaded/ignored)
                lookup_parents = true,
            })
        end,
    })

    -- Markdown превью
    use({
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        cond = is_not_mini,
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
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        event = "BufReadPre",
        config = function()
            require("plugins.lualine")
        end,
        -- after = "noice.nvim",
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
        config = function() end,
    })

    use({
        "windwp/nvim-ts-autotag",
    })
    use({
        "m-demare/hlargs.nvim",
    })

    use({
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_transmute_enabled = 1
            vim.g.matchup_delim_noskips = 1
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_hi_surround_always = 1
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
    use({
        "nvim-treesitter/nvim-treesitter-refactor",
        after = "nvim-treesitter",
    })

    -- Доп утился для языков
    use({
        "simrat39/rust-tools.nvim",
        cond = is_not_mini,
    })
    use({
        "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        cond = is_not_mini,
    })
    use({
        "b0o/schemastore.nvim",
        cond = is_not_mini,
    })
    use({
        "ranelpadon/python-copy-reference.vim",
        cond = is_not_mini,
    })
    use({
        "PatschD/zippy.nvim",
        config = function()
            require("plugins.zippy")
        end,
        cond = is_not_mini,
    })
    -- LSP
    use({
        "neovim/nvim-lspconfig",
        cond = is_not_mini,
    })
    use({
        "williamboman/mason.nvim",
        cond = is_not_mini,
    })
    use({
        "williamboman/mason-lspconfig.nvim",
        cond = is_not_mini,
    })
    use({
        "j-hui/fidget.nvim",
        cond = is_not_mini,
        config = function()
            require("fidget").setup({
                sources = {
                    ["null-ls"] = { ignore = true },
                },
            })
        end,
    })

    use({
        "folke/trouble.nvim",
        cond = is_not_mini,
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
        cond = is_not_mini,
            requires = "neovim/nvim-lspconfig",
            config = function()
                require("nvim-navic").setup({ highlight = true })
                vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
            end,
        })
    end

    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        cond = is_not_mini,
        config = function()
            require("lsp_lines").setup()
        end,
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        cond = is_not_mini,
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
        cond = is_not_mini,
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
    })

    use({
        "weilbith/nvim-code-action-menu",
        cond = is_not_mini,
        cmd = "CodeActionMenu",
    })

    use({
        "filipdutescu/renamer.nvim",
        cond = is_not_mini,
        branch = "master",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("plugins.renamer").config()
        end,
    })

    use({
        "rmagatti/goto-preview",
        cond = is_not_mini,
        config = function()
            require("plugins.preview")
        end,
    })

    -- use({
    --     "ThePrimeagen/refactoring.nvim",
    --     config = function()
    --         require("refactoring").setup({})
    --     end,
    -- })

    use({
        "kevinhwang91/nvim-ufo",
        cond = is_not_mini,
        requires = "kevinhwang91/promise-async",
        event = "BufReadPost",
        after = "nvim-treesitter",
        setup = function() end,
        config = function()
            require("plugins.ufo").config()
        end,
    })

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
    use({ "ray-x/cmp-treesitter", after = "nvim-cmp" })

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
        cond = is_not_mini,
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
        "/projects/diffview.nvim",
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
                    names = false, -- "Name" codes like Blue or blue
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
        cond = is_not_mini,
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
        cond = is_not_mini,
        keymap = "<leader>d",
    })
    use({
        "rcarriga/nvim-dap-ui",
        cond = is_not_mini,
        after = { "nvim-dap" },
        config = function()
            require("dapui").setup()
        end,
    })
    use({
        "theHamsta/nvim-dap-virtual-text",
        cond = is_not_mini,
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

    use({
        "cshuaimin/ssr.nvim",
        cond = is_not_mini,
        module = "ssr",
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
    })

    --- Генераци докстрингов и т.п.
    use({
        "danymat/neogen",
        cond = is_not_mini,
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("neogen").setup({
                enabled = true,
                input_after_comment = true,
                snippet_engine = "luasnip",
            })
        end,
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
                open_autoinsert = true, -- autoinsert when opening
                toggle_autoinsert = true, -- autoinsert when toggling
                autoclose = true, -- autoclose, (no [Process exited 0])
                winenter_autoinsert = true, -- autoinsert when entering the window
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
        cond = is_not_mini,
    })
    use({
        "kristijanhusak/vim-dadbod-ui",
        cond = is_not_mini,
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
        cond = is_not_mini,
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
        cond = is_not_mini,
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
        },
    })
    use({
        "nvim-neotest/neotest-python",
        after = "neotest",
        cond = is_not_mini,
    })
    use({
        "rouge8/neotest-rust",
        after = "neotest",
        cond = is_not_mini,
    })

    -- trim
    use({
        "zakharykaplan/nvim-retrail",
        config = function()
            require("retrail").setup()
        end,
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)
