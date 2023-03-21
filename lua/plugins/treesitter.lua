local M = {}

local syntax_langs = require("colorscheme.lang")

M.setup = function()
    local rainbow = require("ts-rainbow")
    local queries = require("nvim-treesitter.query")
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
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
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
            strategy = rainbow.strategy.global,
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
end

return M
