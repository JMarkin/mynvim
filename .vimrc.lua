-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
require("plugins.nullls").enable({"flake8"}, {"stylua","isort","docformatter"})
require("gentags").enable("python")