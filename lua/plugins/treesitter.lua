local M = {}

local syntax_langs = {
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
    "jsonc",
    "ini",
    "gitignore",
    "git_rebase",
    "graphql",
}

M.plugin = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    dependencies = {
        "windwp/nvim-ts-autotag",
        "m-demare/hlargs.nvim",
        "yioneko/nvim-yati",
        {
            name = "nvim-ts-rainbow",
            enabled = true,
            url = "https://gitlab.com/HiPhish/nvim-ts-rainbow2",
        },
        "nvim-treesitter/nvim-treesitter-refactor",
        {
            "andymass/vim-matchup",
            enabled = true,
            init = function()
                vim.g.matchup_transmute_enabled = 1
                vim.g.matchup_delim_noskips = 1
                vim.g.matchup_matchparen_deferred = 1
                vim.g.matchup_matchparen_hi_surround_always = 1
                vim.g.matchup_matchparen_nomode = "i"
                vim.g.matchup_matchparen_deferred_show_delay = 1000
                vim.g.matchup_matchparen_deferred_hide_delay = 1000
                vim.g.matchup_matchparen_timeout = 100
            end,
        },
    },
    config = function()
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.configs").setup({
            ensure_installed = syntax_langs.treesitter_installed,
            autotag = {
                enable = true,
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = function(_, buf)
                    return not vim.b.large_buf
                end,
            },
            rainbow = {
                enable = true,
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = 1500, -- Do not enable for files with more than n lines, int
                query = {
                    "rainbow-parens",
                    html = "rainbow-tags",
                },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    scope_incremental = "<tab>",
                    node_decremental = "<s-tab>",
                },
            },
            yati = { enable = true },
            indent = {
                enable = false,
            },
            matchup = {
                enable = true,
                include_match_words = true,
            },
            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = false,
                },
                highlight_current_scope = { enable = false },
                smart_rename = {
                    enable = true,
                    keymaps = {
                        smart_rename = "<leader>rr",
                    },
                },
                navigation = {
                    enable = false,
                    keymaps = {
                        goto_definition = "gnd",
                        list_definitions = "gnD",
                        list_definitions_toc = "gO",
                        goto_next_usage = "<a-*>",
                        goto_previous_usage = "<a-#>",
                    },
                },
            },
        })

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
            excluded_argnames = {
                declarations = {},
                usages = {
                    python = {},
                    lua = {},
                },
            },
        })
    end,
}

M.ts_install = function()
    require("nvim-treesitter")
    local cmd = "TSUpdateSync " .. table.concat(syntax_langs.treesitter_installed, " ")
    vim.cmd(cmd)
end

return M
