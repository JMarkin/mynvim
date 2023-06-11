local float_preview = require("custom.floatpreview")

local float_close_decorator = float_preview.close_decorator

local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    float_preview.setup(bufnr, api.tree.get_node_under_cursor)

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))

    vim.keymap.set("n", ".", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))

    vim.keymap.set("n", "<C-t>", float_close_decorator(api.node.open.tab), opts("Open: New Tab"))
    vim.keymap.set("n", "<C-v>", float_close_decorator(api.node.open.vertical), opts("Open: Vertical Split"))
    vim.keymap.set("n", "<C-s>", float_close_decorator(api.node.open.horizontal), opts("Open: Horizontal Split"))
    vim.keymap.set("n", "<CR>", float_close_decorator(api.node.open.edit), opts("Open"))
    vim.keymap.set("n", "<Tab>", float_close_decorator(api.node.open.preview), opts("Open"))
    vim.keymap.set("n", "<S-Tab>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "o", float_close_decorator(api.node.open.edit), opts("Open"))
    vim.keymap.set("n", "O", float_close_decorator(api.node.open.no_window_picker), opts("Open: No Window Picker"))
    vim.keymap.set("n", "q", float_close_decorator(api.tree.close), opts("Close"))

    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
    vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
    vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

    vim.keymap.set("n", "a", float_close_decorator(api.fs.create), opts("Create"))
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
    vim.keymap.set("n", "d", float_close_decorator(api.fs.remove), opts("Delete"))
    vim.keymap.set("n", "r", float_close_decorator(api.fs.rename), opts("Rename"))
    vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
    vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))

    vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))

    vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
    vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
    vim.keymap.set("n", "<F5>", api.node.run.cmd, opts("Run Command"))
    vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
    vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
    vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
    vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
    vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
    vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
    vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
    vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
    vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
    vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
    vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
    vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
    vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
    vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
end

local M = {}

M.plugin = {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    cmd = "NvimTreeOpen",
    init = function()
        vim.keymap.set({ "n" }, { "<space>f", "<A-f>" }, "<Cmd>NvimTreeOpen<CR>", { desc = "FileTree" })
    end,
    config = function()
        require("nvim-tree").setup({
            on_attach = on_attach,
            disable_netrw = true,
            sync_root_with_cwd = false,
            respect_buf_cwd = false,
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            modified = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
            },
            diagnostics = {
                enable = true,
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
                    global = false,
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
        })
    end,
}

return M
