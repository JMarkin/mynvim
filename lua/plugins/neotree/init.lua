return {
    enabled = false,
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
        {
            "<space>f",
            ":Neotree<cr>",
            desc = "FileTree",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        {
            "s1n7ax/nvim-window-picker",
            version = "2.*",
            config = function()
                require("window-picker").setup({
                    filter_rules = {
                        include_current_win = true,
                        autoselect_one = true,
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { "neo-tree", "neo-tree-popup", "notify" },
                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { "terminal", "quickfix" },
                        },
                    },
                })
            end,
        },
        "saifulapm/neotree-file-nesting-config",
    },
    config = function()
        --monkey patch float preview
        local popups = require("neo-tree.ui.popups")

        local old_opts = popups.popup_options
        popups.popup_options = function(name, width, opts)
            if name == "Neo-tree Preview" then
                opts.size = {
                    height = 20,
                    width = opts.size.width,
                }
                return old_opts(name, width, opts)
            end
            return old_opts(name, width, opts)
        end
        local nesting_rules = require("plugins.neotree.nesting_rules")

        require("neo-tree").setup({
            nesting_rules = nesting_rules,
            bind_to_cwd = false,
            close_if_last_window = true,
            log_level = "trace", -- "trace", "debug", "info", "warn", "error", "fatal"
            log_to_file = "/tmp/neotree.log",
            name = {
                trailing_slash = true,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            default_component_configs = {
                symlink_target = {
                    enabled = true,
                },
                indent = {
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "✚", -- NOTE: you can set any of these to an empty string to not show them
                        deleted = "✖",
                        modified = "",
                        renamed = "󰁕",
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                    align = "right",
                },
            },
            commands = {
                copy_selector = function(state)
                    -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
                    -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
                    local node = state.tree:get_node()
                    local filepath = node:get_id()
                    local filename = node.name
                    local modify = vim.fn.fnamemodify

                    local results = {
                        filepath,
                        modify(filepath, ":."),
                        modify(filepath, ":~"),
                        filename,
                        modify(filename, ":r"),
                        modify(filename, ":e"),
                    }

                    vim.ui.select({
                        "1. Absolute path: " .. results[1],
                        "2. Path relative to CWD: " .. results[2],
                        "3. Path relative to HOME: " .. results[3],
                        "4. Filename: " .. results[4],
                        "5. Filename without extension: " .. results[5],
                        "6. Extension of the filename: " .. results[6],
                    }, { prompt = "Choose to copy to clipboard:" }, function(choice)
                        if choice then
                            local i = tonumber(choice:sub(1, 1))
                            if i then
                                local result = results[i]
                                vim.fn.setreg('"', result)
                                vim.notify("Copied: " .. result)
                            else
                                vim.notify("Invalid selection")
                            end
                        else
                            vim.notify("Selection cancelled")
                        end
                    end)
                end,
            },
            window = {
                mappings = {
                    y = "copy_selector",
                    ["<tab>"] = function(state)
                        local node = state.tree:get_node()
                        if not node then
                            return
                        end
                        if require("neo-tree.utils").is_expandable(node) then
                            state.commands["toggle_node"](state)
                        else
                            state.commands["open"](state)
                            vim.cmd("Neotree")
                        end
                    end,
                    ["<s-tab>"] = "close_node",
                    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    ["["] = "prev_source",
                    ["]"] = "next_source",
                    ["<CR>"] = "open_with_window_picker",
                    ["<C-s>"] = "open_split",
                    ["<C-v>"] = "open_vsplit",
                    ["<C-t>"] = "open_tabnew",
                    ["<A-t>"] = function(state)
                        vim.cmd("Neotree toggle")
                        vim.cmd("Sterm")
                    end,
                    ["a"] = {
                        "add",
                        config = {
                            show_path = "relative", -- "none", "relative", "absolute"
                        },
                    },
                },
                popup = { -- settings that apply to float position only
                    size = { height = "40%", width = "50%" },
                    -- position = "50%", -- 50% means center it
                },
            },
            hide_root_node = false,
            retain_hidden_root_indent = true,
            filesystem = {
                filtered_items = {
                    show_hidden_count = false,
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        "node_modules",
                    },
                    always_show_by_pattern = { -- uses glob style patterns
                        ".env*",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        ".DS_Store",
                        "thumbs.db",
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        ".null-ls_*",
                    },
                },
                mappings = {
                    [","] = "navigate_up",
                    ["."] = "set_root",
                },
                use_libuv_file_watcher = true,
            },
            source_selector = {
                winbar = true,
                statusline = false,
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
        })
    end,
}
