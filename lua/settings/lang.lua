local cmd = vim.cmd
local g = vim.g

local M = {}

local Job = require("plenary.job")

M.python = function()
	Job
		:new({
			command = "pip",
			args = { "install", "-U", "doq", "pynvim", "isort", "docformatter" },
		})
		:start()

	g.pydocstring_formatter = "google"
	g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }
	g.pydocstring_doq_path = "~/.pyenv/shims/doq"
end

M.rust = function()
	require("rust-tools").setup({})
	g.neoformat_enabled_rust = { "rustfmt" }
end

M.maps = function(m)
	nnoremap("<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", "GoTo: definition")
	nnoremap("<leader>D", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", "GoTo: definition")
	nnoremap("<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", "GoTo: implementation")
	nnoremap("<leader>r", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "GoTo: references")

	nnoremap("<leader>ld", ":lua require('neogen').generate()<CR>", "Lang: generete docs")
	nnoremap("<leader>lf", "<cmd>lua vim.diagnostic.open_float()<CR>", "Lang: diagnostic float")
	nnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", "Lang: code action")
	vnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>", "Lang: code action")
	nnoremap("<leader>lr", "<cmd>lua require('lspsaga.rename').rename()<CR>", "Lang: rename")
	nnoremap("<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", "Lang: hover")
    

    -- vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
    -- vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
    -- vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
    -- vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
    -- vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
    -- vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
    -- vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
    -- vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
end

return M
