local M = {}

M.setup = function()
    local rainbow = require("ts-rainbow")
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
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
        },

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

    -- original https://github.com/mars90226/dotvim/blob/master/lua/vimrc/plugins/nvim_treesitter.lua#L349-L449
    local configs_commands = require("nvim-treesitter.configs").commands

    -- TODO: Check if these actually help performance, initial test reveals that these may reduce highlighter time, but increase "[string]:0" time which is probably the time spent on autocmd & syntax enable/disable.
    -- TODO: These config help reduce memory usage, see if there's other way to fix high memory usage.
    -- TODO: Change to tab based toggling
    local augroup_id = vim.api.nvim_create_augroup("nvim_treesitter_settings", {})

    local global_idle_disabled_modules = vim.tbl_filter(function(module)
        return module ~= nil
    end, {
        "highlight",
        "navigation",
        "smart_rename",
    })
    local tab_idle_disabled_modules = global_idle_disabled_modules

    local global_trick_delay_enable = false
    local global_trick_delay = 10 * 1000 -- 10 seconds
    vim.api.nvim_create_autocmd({ "FocusGained" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
            if global_trick_delay_enable then
                global_trick_delay_enable = false
            else
                for _, module in ipairs(global_idle_disabled_modules) do
                    configs_commands.TSEnable.run(module)
                end
            end
        end,
    })
    -- NOTE: We want to disable highlight if FocusLost is caused by following reasons:
    -- 1. neovim goes to background
    -- 2. tmux switch window, client
    -- 3. Terminal emulator switch tab
    -- We don't want to disable highlight if FocusLost is caused by following reasons:
    -- 1. tmux switch pane
    -- 2. Terminal emulator switch pane
    -- 3. OS switch application
    -- In other words, we want treesitter highlight if the buffer is actually displayed on the screen.
    vim.api.nvim_create_autocmd({ "FocusLost" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
            global_trick_delay_enable = true

            vim.defer_fn(function()
                if global_trick_delay_enable then
                    for _, module in ipairs(global_idle_disabled_modules) do
                        configs_commands.TSDisable.run(module)
                    end

                    global_trick_delay_enable = false
                end
            end, global_trick_delay)
        end,
    })

    local tab_trick_enable = false
    local tab_trick_debounce = 100
    -- FIXME: Open buffer in other tab doesn't have highlight
    vim.api.nvim_create_autocmd({ "TabEnter" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
            tab_trick_enable = true

            vim.defer_fn(function()
                if tab_trick_enable then
                    local winids = vim.api.nvim_tabpage_list_wins(0)

                    for _, module in ipairs(tab_idle_disabled_modules) do
                        for _, winid in ipairs(winids) do
                            configs_commands.TSBufEnable.run(module, vim.api.nvim_win_get_buf(winid))
                        end
                    end

                    tab_trick_enable = false
                end
            end, tab_trick_debounce)
        end,
    })
    vim.api.nvim_create_autocmd({ "TabLeave" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
            for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                for _, module in ipairs(tab_idle_disabled_modules) do
                    configs_commands.TSBufDisable.run(module, vim.api.nvim_win_get_buf(winid))
                end
            end
        end,
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
