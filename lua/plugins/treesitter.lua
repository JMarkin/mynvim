require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "lua",
        "rust",
        "cpp",
        "cuda",
        "python",
        "vim",
        "typescript",
        "javascript",
        "yaml",
        "toml",
        "make",
        "fish",
        "go",
        "html",
        "css",
        "bash",
        "dockerfile",
        "vue",
        "scss",
    },
    indent = {
        enable = false,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = false,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1500, -- Do not enable for files with more than n lines, int
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gi",
            node_incremental = "gnn",
            scope_incremental = "gss",
            node_decremental = "gnd",
        },
    },
    yati = { enable = true },
    matchup = {
        enable = true,
    },
})
