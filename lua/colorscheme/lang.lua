local M = {}

M.treesitter_installed = {
    "regex",
    "rust",
    "cpp",
    "cuda",
    "python",
    "typescript",
    "javascript",
    "jsdoc",
    "yaml",
    "toml",
    "proto",
    "http",
    "scss",
    "make",
    "cmake",
    "fish",
    "go",
    "html",
    "css",
    "bash",
    "dockerfile",
    "vue",
    "scss",
    "sql",
    "markdown",
    "markdown_inline",
    "json",
}

M.polyglot_disabled = {
    "vim",
    "lua",
    "help",
    "c",
    "query",
}

for _, value in ipairs(M.treesitter_installed) do
    table.insert(M.polyglot_disabled, value)
end

return M
