local M = {}

M.pyright = function()
	return {
		settings = {
			python = {
				disableOrganizeImports = true,
				analysis = {
					typeCheckingMode = "off",
					logLevel = "Error",
					diagnosticMode = "workspace",
				},
			},
		},
	}
end

M.pylsp = function()
	require("settings.lang").python()
	return {
		settings = {
			pylsp = {
				configurationSources = {},
				plugins = {
					flake8 = {
						enabled = false,
					},
					mccabe = {
						enabled = false,
					},
					pycodestyle = {
						enabled = false,
					},
					pydocstyle = {
						enabled = false,
					},
					pyflakes = {
						enabled = false,
					},
					pylint = {
						enabled = false,
					},
					yapf = {
						enabled = false,
					},
				},
			},
		},
	}
end

M.setup = function()
	vim.g.coq_settings = {
		auto_start = true,
		match = {
			max_results = 17,
		},
		clients = {
			tmux = {
				enabled = false,
			},
		},
	}
end

M.config = function()
	local present, lsp_installer = pcall(require, "nvim-lsp-installer")
	if not present then
		return
	end

	local present, coq = pcall(require, "coq")
	if not present then
		return
	end

	local lsp = M

	lsp_installer.on_server_ready(function(server)
		local opts = vim.g[server.name .. "_config"]
		if opts ~= nil then
			print("use local lsp config", server.name)
		else
			opts = lsp[server.name]
			if opts ~= nil then
				opts = opts()
				print("use custom config", server.name)
			else
				opts = {}
			end
		end
		vim.g[server.name .. "_config"] = opts
		opts = coq.lsp_ensure_capabilities(opts)
		server:setup(opts)
	end)

	require("lspsaga").setup({
		finder_action_keys = {
			open = "<cr>",
			vsplit = "v",
			split = "s",
			quit = "q",
		},
	})
	require("lsp_signature").setup()
	require("lsp-colors").setup({
		Error = "#E82424",
		Warning = "#FF9E3B",
		Information = "#6A9589",
		Hint = "#658594",
	})
	require("trouble").setup({
		padding = false,
		auto_open = false,
		auto_close = false,
		auto_preview = false,
		auto_fold = true,
		action_keys = { -- key mappings for actions in the trouble list
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
			open_split = { "<c-x>", "s" }, -- open buffer in new split
			open_vsplit = { "<c-v>", "v" }, -- open buffer in new vsplit
			open_tab = { "<c-t>" }, -- open buffer in new tab
			jump_close = { "o" }, -- jump to the diagnostic and close the list
			toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
			toggle_preview = "P", -- toggle auto_preview
			hover = "K", -- opens a small popup with the full multiline message
			preview = "p", -- preview the diagnostic location
			close_folds = { "zM", "zm" }, -- close all folds
			open_folds = { "zR", "zr" }, -- open all folds
			toggle_fold = { "zA", "za" }, -- toggle fold of current file
			previous = "k", -- preview item
			next = "j", -- next item
		},
		use_diagnostic_signs = true,
	})

	vim.diagnostic.config({
		underline = true,
		signs = true,
		virtual_text = true,
		float = true,
		update_in_insert = false, -- default to false
		severity_sort = true, -- default to false
	})
	vim.o.updatetime = 150
	vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]])
end

return M
