local present, packer = pcall(require, "plugins.initpacker")

if not present then
	return false
end

local use = packer.use

return packer.startup(function()
	use({ "stevearc/dressing.nvim" })
	use({
		"nvim-lua/plenary.nvim",
	})

	use({
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({})
		end,
	})

	use("MarcWeber/vim-addon-local-vimrc")

	use({
		"wbthomason/packer.nvim",
		cmd = { "PackerCompile", "PackerInstall", "PackerSync" },
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.opt.list = true
			vim.opt.listchars:append("space:⋅")
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
	use({
		"Mofiqul/dracula.nvim",
	})
	use("bluz71/vim-moonfly-colors")
	use("ray-x/aurora")
	use("Iron-E/nvim-highlite")

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

	-- Автокомплиты
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use({
		"RishabhRD/nvim-lsputils",
		requires = "RishabhRD/popfix",
	})
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
	--    	use({
	-- 	"akinsho/bufferline.nvim",
	-- 	requires = "kyazdani42/nvim-web-devicons",
	-- 	after = "mapx",
	-- 	config = function()
	-- 		require("plugins.bufferline")
	-- 	end,
	-- })
	use({
		"jose-elias-alvarez/buftabline.nvim",
		requires = { "kyazdani42/nvim-web-devicons" }, -- optional!
		config = function()
			require("buftabline").setup({})
		end,
	})
	use("Asheq/close-buffers.vim")
	use({
		"kwkarlwang/bufresize.nvim",
		after = "mapx",
		config = function()
			require("plugins.bufresize")
		end,
	})

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
		requires = {
			{ "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
		},
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

	-- подцветка ошибок вне lsp
	use({
		"folke/lsp-colors.nvim",
		require("lsp-colors").setup(),
	})

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

	use({
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup()
		end,
	})
end)
