-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
if vim.env.NVIM_MINI == nil then
    require("plugins.nullls").enable(nil, nil, nil)
end
vim.g.db = "postgresql://postgres:postgres@localhost:5432/postgres"

if vim.fn.executable("ctags") == 1 then
    require("gentags").enable("lua,python")
end
