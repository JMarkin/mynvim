local DEFAULT_DIAGNOSTICS = {
    "ruff",
    "protolint",
    "curlylint",
    "sqlfluff",
}
local DEFAULT_FORMATTERS = {
    "sqlfluff",
    "ruff",
    "black",
    "yamlfmt",
    "protolint",
    "stylua",
    "djhtml",
    "isort",
    "nginx_beautifier",
    "taplo",
    "prettierd",
}

return {
    enabled = false,
    "creativenull/efmls-configs-nvim",
    requires = { "neovim/nvim-lspconfig" },
    build = "go install github.com/mattn/efm-langserver@latest",
    config = function() end,
}
