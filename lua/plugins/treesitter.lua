local M = {}

local is_large_file = require("custom.largefiles").is_large_file

local syntax_langs = {
    -- languages
    "rust",
    "c",
    "cpp",
    "cuda",
    "python",
    "typescript",
    "javascript",
    "fish",
    "go",
    "html",
    "htmldjango",
    "css",
    "bash",
    "vue",
    "scss",
    "sql",
    "markdown",
    "json",
    "json5",
    "jsonc",
    "graphql",
    -- conf files
    "jsdoc",
    "yaml",
    "toml",
    "proto",
    "http",
    "make",
    "cmake",
    "dockerfile",
    "ini",
    "gitignore",
    "vim",
    "vimdoc",
    "passwd",
    "requirements",
    "hcl",
    -- tools
    "markdown_inline",
    "jq",
    "regex",
    "git_rebase",
    "query",
    "comment",
}

---@diagnostic disable-next-line: unused-local
local is_disable = function(_lang, _buf)
    return is_large_file(_buf, true)
end

M.plugin = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    dependencies = {
        "m-demare/hlargs.nvim",
        "yioneko/nvim-yati",
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/playground",
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
        {
            "HiPhish/rainbow-delimiters.nvim",
            -- enabled = false,
            config = function()
                local rainbow_delimiters = require("rainbow-delimiters")
                require("rainbow-delimiters.setup")({
                    strategy = {
                        [""] = rainbow_delimiters.strategy["global"],
                        commonlisp = rainbow_delimiters.strategy["local"],
                    },
                    query = {
                        [""] = "rainbow-delimiters",
                        latex = "rainbow-blocks",
                    },
                    highlight = {
                        "RainbowDelimiterRed",
                        "RainbowDelimiterYellow",
                        "RainbowDelimiterBlue",
                        "RainbowDelimiterOrange",
                        "RainbowDelimiterGreen",
                        "RainbowDelimiterViolet",
                        "RainbowDelimiterCyan",
                    },
                    blacklist = {},
                })
            end,
        },
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.configs").setup({
            -- ensure_installed = syntax_langs,
            playground = {
                enable = true,
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
                disable = is_disable,
            },
            autotag = {
                enable = false,
                disable = is_disable,
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    scope_incremental = "<tab>",
                    node_decremental = "<s-tab>",
                },
                disable = is_disable,
            },
            context_commentstring = {
                enable = true,
            },
            yati = {
                enable = true,
                disable = is_disable,
            },
            indent = {
                enable = false,
            },
            matchup = {
                enable = true,
                include_match_words = true,
                disable = is_disable,
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
                disable = is_disable,
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
            disable = is_disable,
        })
    end,
}

M.install = function(sync)
    require("nvim-treesitter")
    for _, lang in ipairs(syntax_langs) do
        if sync then
            vim.cmd("TSUpdateSync " .. lang)
        else
            vim.cmd("TSUpdate " .. lang)
        end
    end
end

return M
