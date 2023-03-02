-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
require("plugins.nullls").enable(nil,nil,nil)
require("gentags").enable("lua,python")
vim.g.db = 'postgresql://postgres:postgres@localhost:5432/postgres'
