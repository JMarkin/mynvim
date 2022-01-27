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

	--- вместо ESC просто jj
	use({
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({})
		end,
	})

	--- Локальный настройки дял папки с помощью .lvimrc с хэшем
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
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.filetree")
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
	use("p00f/nvim-ts-rainbow")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
		after = { "nvim-ts-rainbow" },
	})

	use("yamatsum/nvim-cursorline")
	use({
		"romgrk/nvim-treesitter-context",
		after = { "nvim-treesitter" },
		config = function()
			require("treesitter-context").setup()
		end,
	})

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use({
		"RishabhRD/nvim-lsputils",
		requires = "RishabhRD/popfix",
	})
	use({
		"tami5/lspsaga.nvim",
		config = function()
			require("lspsaga").init_lsp_saga()
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup()
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})

	use({
		"ray-x/lsp_signature.nvim",
	})
	use({
		"folke/lsp-colors.nvim",
		require("lsp-colors").setup(),
	})

	--- Автокомлиты
	use({
		"ms-jpq/coq_nvim",
		after = { "nvim-lsp-installer" },
		setup = function()
			require("plugins.coq").setup()
		end,
		run = function()
			vim.cmd(":COQdeps")
		end,
		config = function()
			require("plugins.coq").config()
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
	use("liuchengxu/vista.vim")

	-- LazyGit
	use("kdheepak/lazygit.nvim")

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
	use("powerman/vim-plugin-ruscmd")

	-- popup окошки
	use("nvim-lua/popup.nvim")

	-- Линтеры
	use("neomake/neomake")

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
	use("nathom/filetype.nvim")

	-- editorconfig
	use("editorconfig/editorconfig-vim")

	-- gtags
	use("jsfaint/gen_tags.vim")

	--- поиски по фалам првоеркам и т.п. fzf вобщем
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
end)
