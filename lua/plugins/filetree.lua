local M = {}

local list = {
    { key = { "<CR>", "o", "<2-LeftMouse>", "<Tab>" }, action = "edit" },
    { key = { "O" }, action = "edit_no_picker" },
    { key = "v", action = "vsplit" },
    { key = "s", action = "split" },
    { key = "<C-t>", action = "tabnew" },
    { key = "<", action = "prev_sibling" },
    { key = ">", action = "next_sibling" },
    { key = "P", action = "parent_node" },
    { key = "<BS>", action = "close_node" },
    { key = "K", action = "first_sibling" },
    { key = "J", action = "last_sibling" },
    { key = "I", action = "toggle_ignored" },
    { key = "H", action = "toggle_dotfiles" },
    { key = "R", action = "refresh" },
    { key = "a", action = "create" },
    { key = "d", action = "remove" },
    { key = "r", action = "rename" },
    { key = "<C-r>", action = "full_rename" },
    { key = "x", action = "cut" },
    { key = "c", action = "copy" },
    { key = "p", action = "paste" },
    { key = "y", action = "copy_name" },
    { key = "Y", action = "copy_path" },
    { key = "gy", action = "copy_absolute_path" },
    { key = "-", action = "dir_up" },
    { key = "q", action = "close" },
    { key = "g?", action = "toggle_help" },
}

M.config = function()
    require("nvim-tree").setup({
        auto_reload_on_write = true,
        disable_netrw = true,
        open_on_setup = false,
        hijack_netrw = true,
        ignore_buffer_on_setup = true,
        hijack_cursor = true,
        open_on_tab = true,
        view = {
            preserve_window_proportions = true,
            mappings = {
                list = list,
            },
        },
        update_focused_file = {
            enable = false,
        },
        actions = {
            open_file = {
                quit_on_open = true,
                window_picker = {
                    enable = true,
                },
            },
        },
        renderer = {
            highlight_opened_files = "all",
            add_trailing = true,
        },
        create_in_closed_folder = true,
    })
end

M.setup = function()
    vim.g.nvim_tree_refresh_wait = 500
end

return M
