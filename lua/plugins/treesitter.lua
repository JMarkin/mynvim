local M = {}

M.setup = function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "c",
            "rust",
            "cpp",
            "cuda",
            "python",
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
            "lua",
            "vim",
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
                init_selection = "gi",
                node_incremental = "gnn",
                scope_incremental = "gss",
                node_decremental = "gnd",
            },
        },
        yati = { enable = true },
        matchup = {
            enable = false,
        },
    })

    require("nvim-ts-autotag").setup()

    require("hlargs").setup({
        use_colorpalette = true,
        paint_arg_declarations = true,
        paint_arg_usages = true,
        paint_catch_blocks = {
            declarations = true,
            usages = true,
        },
        extras = {
            named_parameters = true,
        },
    })
end

return M
