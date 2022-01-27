local M = {}

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

	local lsp = require("plugins.lsp")

	lsp_installer.on_server_ready(function(server)
		local opts = lsp[server.name]
		if opts ~= nil then
			opts = lsp[server.name]()
		else
			opts = {}
		end
		server:setup(coq.lsp_ensure_capabilities(opts))
	end)

	require("lsp_signature").setup()
end

return M
