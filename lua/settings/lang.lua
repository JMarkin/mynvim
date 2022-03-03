local cmd = vim.cmd
local g = vim.g

local M = {}

local Job = require("plenary.job")

M.python = function()
	-- Job
	-- 	:new({
	-- 		command = "pip",
	-- 		args = { "install", "-U", "doq", "pynvim", "isort", "docformatter" },
	-- 	})
	-- 	:start()

	g.pydocstring_formatter = "google"
	g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }
    g.neomake_python_enabled_makers = {'python', 'flake8'}

	g.pydocstring_doq_path = "~/.pyenv/shims/doq"
end

M.rust = function()
	g.neoformat_enabled_rust = { "rustfmt" }
    g.neoformat_rust_rustfmt = {
        exe = 'rustfmt',
        args = {'--edition', '2021'},
        stdin = 1
    }
end

M.maps = function(m)
	nnoremap("<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", "GoTo: definition")
	nnoremap("<leader>D", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", "GoTo: definition")
	nnoremap("<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", "GoTo: implementation")
	nnoremap("<leader>r", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "GoTo: references")

	nnoremap("<leader>ld", ":lua require('neogen').generate()<CR>", "Lang: generete docs")
	nnoremap("<leader>li", "<cmd>lua vim.diagnostic.open_float()<CR>", "Lang: diagnostic float")
	nnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", "Lang: code action")
	vnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>", "Lang: code action")
	nnoremap("<leader>lr", "<cmd>lua require('lspsaga.rename').rename()<CR>", "Lang: rename")
	nnoremap("<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", "Lang: hover")
	nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", "Lang: lsp format")

end

return M
