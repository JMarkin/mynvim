local present, packer = pcall(require, "plugins.initpacker")

if not present then
	return false
end

local use = packer.use

return packer.startup(function()
	--- Украшения
	use({
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	})
	use({
		"gelguy/wilder.nvim",
		requires = { "sharkdp/fd", "nixprime/cpsm", "romgrk/fzy-lua-native" },
		config = function()
			require("plugins.wilder")
		end,
	})
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
	use("MarcWeber/vim-addon-local-vimrc")

	use({
		"wbthomason/packer.nvim",
		cmd = { "PackerCompile", "PackerInstall", "PackerSync" },
	})

	--- Подцветка отступов
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.opt.list = true
			-- vim.opt.listchars:append("space:⋅")
			vim.g.indent_blankline_context_patterns = { "class", "function", "method", "if" }

			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})
	-- Цвет тема
	use({
		"sainnhe/gruvbox-material",
	})
	use({
		"sainnhe/sonokai",
	})
	use("Iron-E/nvim-highlite")
	use("rmehri01/onenord.nvim")
	use("rebelot/kanagawa.nvim")

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
		after = "which-key.nvim",
		config = function()
			local m = require("mapx").setup({ global = true, whichkey = true })
			require("settings.view")(m)
			require("settings.search")(m)
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
	use({
		"p00f/nvim-ts-rainbow",
		config = function()
			require("plugins.treesitter")
		end,
		after = { "nvim-treesitter", "nvim-treesitter-context" },
	})

	use("yamatsum/nvim-cursorline")

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	-- use({
	-- 	"RishabhRD/nvim-lsputils",
	-- 	requires = "RishabhRD/popfix",
	-- })
	use({
		"tami5/lspsaga.nvim",
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
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
			require("plugins.bufferline")
		end,
	})
	use("Asheq/close-buffers.vim")

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
			require("plugins.filetype")
		end,
	})

	-- editorconfig
	use("editorconfig/editorconfig-vim")

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

	--- fold
	use({
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup({})
			require("pretty-fold.preview").setup()
		end,
	})

	---удаление traling
	use({ "McAuleyPenney/tidy.nvim", event = "BufWritePre" })

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
		"chr4/sslsecure.vim",
		ft = "nginx",
	})

	-- выключаем yank на del
	use({
		"gbprod/cutlass.nvim",
		config = function()
			require("cutlass").setup({
				cut_key = "m",
			})
		end,
	})
end)
