local maxline = require("funcs").maxline
local ifind = require("funcs").ifind

local ignore_dirs_t = { ".git", ".venv", ".ruff_cache", ".mypy_cache", ".pytest_cache" }

local function on_attach(bufnr)
    local api = require("nvim-tree.api")
    local FloatPreview = require("float-preview")

    local git_add = function()
        local node = api.tree.get_node_under_cursor()
        local gs = node.git_status.file

        -- If the current node is a directory get children status
        if gs == nil then
            gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
                or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
        end

        -- If the file is untracked, unstaged or partially staged, we stage it
        if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
            vim.cmd("silent !git add " .. node.absolute_path)

        -- If the file is staged, we unstage
        elseif gs == "M " or gs == "A " then
            vim.cmd("silent !git restore --staged " .. node.absolute_path)
        end

        api.tree.reload()
    end

    FloatPreview.attach_nvimtree(bufnr)

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))

    vim.keymap.set("n", ".", function(...)
        local node = api.tree.get_node_under_cursor()
        if node.type == "file" then
            api.tree.change_root_to_node(node.parent)
        else
            api.tree.change_root_to_node(...)
        end
    end, opts("CD"))
    vim.keymap.set("n", ",", api.tree.change_root_to_parent, opts("Up"))

    vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<Tab>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<S-Tab>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
    vim.keymap.set("n", "q", api.tree.close, opts("Close"))

    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
    vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
    vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

    vim.keymap.set("n", "a", api.fs.create, opts("Create"))
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    vim.keymap.set("n", "r", api.fs.rename, opts("Rename: Filename"))

    vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))

    vim.keymap.set("n", "<F5>", api.node.run.cmd, opts("Run Command"))
    vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
    vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
    vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
    vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
    vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
    vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
    vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
    vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
    vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))

    vim.keymap.set("n", "ga", git_add, opts("Git Add"))
end

return {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    cmd = "NvimTreeOpen",
    -- dev = true,
    -- dir = "~/projects/nvim-tree.lua",
    dependencies = {
        "antosha417/nvim-lsp-file-operations",
        {
            "JMarkin/nvim-tree.lua-float-preview",
            lazy = true,
            dev = true,
            dependencies = { "nvim-treesitter" },
            opts = {
                -- toggled_on = false,
                hooks = {
                    pre_open = function(path)
                        local is_showed = require("float-preview.utils").is_showed(path)
                        if is_showed then
                            return false
                        end
                        local is_text = require("float-preview.utils").is_text(path)
                        if not is_text then
                            return false
                        end

                        -- if file > 5 MB or not text -> not preview
                        local size = require("float-preview.utils").get_size(path)
                        if type(size) ~= "number" then
                            return false
                        end

                        if size > 5 then
                            return false
                        end

                        -- len
                        local len = maxline(path)
                        if type(len) ~= "number" then
                            return false
                        end

                        if len > vim.o.synmaxcol then
                            return false
                        end

                        return true
                    end,
                    post_open = function(bufnr)
                        return true
                    end,
                },
            },
        },
    },
    init = function()
        vim.keymap.set({ "n" }, { "<space>f", "<A-f>" }, "<Cmd>NvimTreeOpen<CR>", { desc = "FileTree" })
    end,
    config = function()
        require("lsp-file-operations").setup()
        require("nvim-tree").setup({
            on_attach = on_attach,
            disable_netrw = false,
            sync_root_with_cwd = false,
            respect_buf_cwd = false,
            update_focused_file = {
                enable = false,
                update_root = false,
            },
            modified = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
            },
            diagnostics = {
                enable = false,
            },
            renderer = {
                group_empty = true,
                highlight_git = true,
                add_trailing = true,
                highlight_opened_files = "all",
                highlight_modified = "none",
            },
            actions = {
                use_system_clipboard = true,
                change_dir = {
                    enable = true,
                    global = true,
                    restrict_above_cwd = false,
                },
                expand_all = {
                    max_folder_discovery = 300,
                    exclude = {},
                },
                file_popup = {
                    open_win_config = {
                        col = 1,
                        row = 1,
                        relative = "cursor",
                        border = "shadow",
                        style = "minimal",
                    },
                },
                open_file = {
                    quit_on_open = true,
                    resize_window = true,
                    window_picker = {
                        enable = true,
                        picker = "default",
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                            buftype = { "nofile", "terminal", "help" },
                        },
                    },
                },
                remove_file = {
                    close_window = true,
                },
            },
            git = {
                enable = true,
                disable_for_dirs = ignore_dirs_t,
            },
            filesystem_watchers = {
                ignore_dirs = ignore_dirs_t,
            },
        })
    end,
}
