vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --- Украшения
    use({
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup()
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
        "nvim-lua/plenary.nvim",
    })

    use({
        "b0o/incline.nvim",
        setup = function()
            vim.opt.laststatus = 3
        end,
        config = function()
            require("incline").setup()
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
            local alpha = require("alpha")
            local startify = require("alpha.themes.startify")
            startify.section.header.val = {
                [[                                   __                ]],
                [[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
                [[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
                [[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
                [[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
                [[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
            }
            startify.section.top_buttons.val = {
                startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            }
            -- disable MRU
            startify.section.mru.val = { { type = "padding", val = 0 } }
            -- disable nvim_web_devicons
            startify.section.bottom_buttons.val = {
                startify.button("q", "  Quit NVIM", ":qa<CR>"),
            }
            startify.section.footer = {
                { type = "text", val = "footer" },
            }
            alpha.setup(startify.config)
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
                lookup_parents = false,
            })
        end,
    })

    -- Markdown превью
    use({ "ellisonleao/glow.nvim" })

    -- Цвет тема
    use("rebelot/kanagawa.nvim")
    use("Iron-E/nvim-highlite")
    use("Avimitin/neovim-deus")
    use("rktjmp/lush.nvim")

    -- Информационная строка внизу
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("plugins.colors")()
        end,
    })

    -- Файловый менеджер
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        setup = function()
            require("plugins.filetree").setup()
        end,
        config = function()
            require("plugins.filetree").config()
        end,
    })

    -- Подцветка синтаксиа
    use({
        "nvim-treesitter/nvim-treesitter",
    })
    use({ "yioneko/nvim-yati" })

    use({
        "windwp/nvim-ts-autotag",
    })
    use({
        "m-demare/hlargs.nvim",
    })

    use({
        "p00f/nvim-ts-rainbow",
        config = function()
            require("plugins.treesitter")
        end,
        after = { "hlargs.nvim", "nvim-treesitter", "nvim-yati", "nvim-ts-autotag" },
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent")
        end,
    })

    -- LSP
    use("neovim/nvim-lspconfig")
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    use({ "glepnir/lspsaga.nvim" })

    use({
        "ray-x/lsp_signature.nvim",
    })

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
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })
    use("j-hui/fidget.nvim")

    --- Автокомлиты
    use({
        "JMarkin/coq_nvim",
        after = "nvim-config-local",
        setup = function()
            require("plugins.lsp").setup()
        end,
        run = function()
            vim.cmd(":COQdeps")
        end,
        config = function()
            require("plugins.lsp").config()
        end,
    })
    use({
        "ms-jpq/coq.artifacts",
        after = "coq_nvim",
    })

    use({
        "JMarkin/gentags.lua",
        config = function()
            require("gentags").setup()
        end,
    })

    -- Табы
    use("Asheq/close-buffers.vim")
    --
    use({ "mrjones2014/smart-splits.nvim" })

    -- Навигация внутри файла по классам и функциям
    use({ "simrat39/symbols-outline.nvim" })

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

    -- Colorize
    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    })

    -- Комментирование
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- EasyMotion
    use({
        "ggandor/lightspeed.nvim",
        config = function()
            require("lightspeed").setup({})
        end,
    })

    -- Форматер
    use("sbdchd/neoformat")

    -- Дебагер
    use("mfussenegger/nvim-dap")
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

    -- Доп утился дял языков
    use({
        "simrat39/rust-tools.nvim",
    })
    use("https://git.sr.ht/~p00f/clangd_extensions.nvim")
    use("b0o/schemastore.nvim")

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
            require("plugins.fzflua")
        end,
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

    use({
        "ethanholz/nvim-lastplace",
        config = function()
            require("nvim-lastplace").setup({})
        end,
    })

    -- bookmark
    use({
        "MattesGroeger/vim-bookmarks",
        after = { "mapx" },
        setup = function()
            require("plugins.bookmark").setup()
        end,
    })

    -- профилировщик оптимизатор neovim
    use({
        "lewis6991/impatient.nvim",
    })

    -- обноление cursorhold
    use("antoinemadec/FixCursorHold.nvim")

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

    -- db
    use({
        "kristijanhusak/vim-dadbod-ui",
        requires = { "tpope/vim-dadbod" },
    })

end)
