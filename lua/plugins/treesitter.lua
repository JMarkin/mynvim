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
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1500, -- Do not enable for files with more than n lines, int
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    yati = { enable = true },
})

local present_hlargs, ts_hlargs = pcall(require, "hlargs")
if present_hlargs then
    ts_hlargs.setup({
        use_colorpalette=true,
    })
end

local present_atag, ts_atag = pcall(require, "nvim-ts-autotag")
if present_atag then
    ts_atag.setup()
end
