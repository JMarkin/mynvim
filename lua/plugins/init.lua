local packer, bootstrap = require("plugins.initpacker")

local use = packer.use

return packer.startup(function()
    --- Украшения
    use({
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup()
        end,
    })
    -- use({
    --     "gelguy/wilder.nvim",
    --     requires = { "sharkdp/fd", "nixprime/cpsm", "romgrk/fzy-lua-native" },
    --     config = function()
    --         require("plugins.wilder")
    --     end,
    -- })
    use({
        "nvim-lua/plenary.nvim",
    })

    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end,
    })

    --- вместо ESC просто jj
    use({
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({})
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
            })
        end,
    })

    use({
        "wbthomason/packer.nvim",
        cmd = { "PackerCompile", "PackerInstall", "PackerSync" },
    })

    --- Подцветка отступов
    -- use({
    --     "lukas-reineke/indent-blankline.nvim",
    --     config = function()
    --         require("plugins.indent")
    --     end,
    -- })
    -- Цвет тема
    use({
        "sainnhe/sonokai",
    })
    use("rmehri01/onenord.nvim")
    use("rebelot/kanagawa.nvim")
    use("Mofiqul/dracula.nvim")
    use("olimorris/onedarkpro.nvim")
    use("luisiacc/gruvbox-baby")
    use("folke/tokyonight.nvim")

    -- Markdown превью
    use({ "ellisonleao/glow.nvim" })

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

    -- Классная штука по отображению shortcut
    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end,
    })

    -- Удобный способ задания shortcut с интеграцией в which-key
    use({
        "b0o/mapx.nvim",
        as = "mapx",
        after = { "which-key.nvim", "smart-splits.nvim" },
        config = function()
            local m = require("mapx").setup({ global = "force", whichkey = true })
            require("settings.view")(m)
            require("settings.search").maps(m)
            require("settings.lang").maps(m)
            require("settings.common")(m)
        end,
    })

    -- Подцветка синтаксиа
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use({
        "romgrk/nvim-treesitter-context",
    })

    -- use({
    --     "m-demare/hlargs.nvim",
    --     requires = { "nvim-treesitter/nvim-treesitter" },
    -- })

    use({
        "windwp/nvim-ts-autotag",
        after = { "nvim-treesitter", "nvim-treesitter-context" },
        config = function()
            require("plugins.treesitter")
        end,
    })

    -- вырубаем до stable ветки т.к. разрабочтик делает под master
    -- use({
    -- 	"p00f/nvim-ts-rainbow",
    -- 	config = function()
    -- 		require("plugins.treesitter")
    -- 	end,
    -- 	after = { "nvim-treesitter", "nvim-treesitter-context" },
    -- })
    -- LSP
    use("neovim/nvim-lspconfig")
    use("williamboman/nvim-lsp-installer")
    use({
        "tami5/lspsaga.nvim",
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.nullls")
        end,
    })

    use({
        "ray-x/lsp_signature.nvim",
    })
    use({
        "folke/lsp-colors.nvim",
    })

    use({ "kevinhwang91/nvim-bqf", ft = "qf" })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })
    use("j-hui/fidget.nvim")

    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    })
    --- Автокомлиты
    use({
        "ms-jpq/coq_nvim",
        after = {
            "nvim-lsp-installer",
            "lspsaga.nvim",
            "lsp_signature.nvim",
            "null-ls.nvim",
            "lsp-colors.nvim",
            "trouble.nvim",
            "lsp_lines.nvim",
        },
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

    -- Табы
    use({
        "akinsho/bufferline.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("plugins.buffers")
        end,
    })
    use("Asheq/close-buffers.vim")

    use({ "mrjones2014/smart-splits.nvim" })

    -- Навигация внутри файла по классам и функциям
    use({
        "liuchengxu/vista.vim",
        setup = function()
            require("plugins.vista")
        end,
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

    -- Даже если включена русская раскладка vim команды будут работать
    -- use("powerman/vim-plugin-ruscmd")

    -- EasyMotion
    use({
        "ggandor/lightspeed.nvim",
        config = function()
            require("lightspeed").setup({})
        end,
    })

    -- popup окошки
    use("nvim-lua/popup.nvim")

    -- Линтеры испольузем null-ls
    -- use("neomake/neomake")

    -- Форматер
    use("sbdchd/neoformat")

    -- Дебагер
    use("mfussenegger/nvim-dap")
    use({
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
        after = { "nvim-treesitter", "nvim-dap" },
    })

    -- Неплохой модуль для раст
    use({
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        config = function()
            require("settings.lang").rust()
        end,
    })

    -- профилировщик оптимизатор neovim
    use({
        "lewis6991/impatient.nvim",
    })
    use({
        "nathom/filetype.nvim",
        config = function()
            require("plugins.nvimfiletype")
        end,
    })

    -- editorconfig
    use("gpanders/editorconfig.nvim")

    -- gtags
    use("jsfaint/gen_tags.vim")

    --- поиски по файлам проверкам и т.п. fzf вобщем
    use({
        "ibhagwan/fzf-lua",
        requires = {
            "vijaymarupudi/nvim-fzf",
            "kyazdani42/nvim-web-devicons",
        },
    })

    --- Генераци докстрингов и т.п.
    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({
                enabled = true,
            })
        end,
        requires = "nvim-treesitter/nvim-treesitter",
    })

    --- Стабилизация табов и буферов при ресайзе терминала
    use({
        "luukvbaal/stabilize.nvim",
        config = function()
            require("stabilize").setup()
        end,
    })

    use({
        "https://gitlab.com/yorickpeterse/nvim-window",
        config = function()
            require("nvim-window").setup({})
        end,
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

    -- minimap
    -- use({
    --     "wfxr/minimap.vim",
    --     setup = function()
    --         require("plugins.minimap").setup()
    --     end,
    --     config = function()
    --         require("plugins.minimap").config()
    --     end,
    -- })

    -- bookmark
    use({
        "MattesGroeger/vim-bookmarks",
        after = { "mapx" },
        setup = function()
            require("plugins.bookmark").setup()
        end,
        config = function()
            require("plugins.bookmark").config()
        end,
    })

    if bootstrap then
        require("packer").sync()
    end
end)
