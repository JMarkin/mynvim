local cmd = vim.cmd 
local g = vim.g

local M = {}

local Job = require'plenary.job'


M.python = function()
    Job:new({
        command = "pip",
        args = {"install", "-U", "doq", "pynvim", "isort", "docformatter"},
    }):start()

    g.pydocstring_formatter = 'google'
    g.neoformat_enabled_python = {'yapf','isort', 'docformatter'}
    g.pydocstring_doq_path = '~/.pyenv/shims/doq'
end

M.rust = function()
require('rust-tools').setup({})
g.neoformat_enabled_rust = {'rustfmt'}
end


M.maps = function(m) 

nnoremap("<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", "GoTo: definition")
nnoremap("<leader>D", "<cmd>lua vim.lsp.buf.declaration()<CR>", "GoTo: declaration")
nnoremap("<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", "GoTo: implementation")
nnoremap("<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", "GoTo: references")

m.nname("<leader>l", "Lang")
nnoremap("<leader>ld", "<Plug>(pydocstring)", "Lang: generete docs")

end



return M
