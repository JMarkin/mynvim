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
	local config = vim.g.pylsp_config
	if config ~= nil then
		print("use local lsp config")
		return config
	end
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

return M
