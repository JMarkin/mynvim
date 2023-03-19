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
    "htmldjango",
    "css",
    "bash",
    "dockerfile",
    "vue",
    "scss",
    "sql",
    "markdown",
    "markdown_inline",
    "json",
    "ini",
    "cuda",
    "gitignore",
    "git_rebase",
    "graphql",
}

M.polyglot_disabled = {
    "vim",
    "lua",
    "help",
    "c",
    "query",
}

M.tree_lang_map = { vim = true, lua = true, help = true, c = true, query = true }

for _, value in ipairs(M.treesitter_installed) do
    table.insert(M.polyglot_disabled, value)
    M.tree_lang_map[value] = true
end

return M
