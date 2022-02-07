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
		disable_netrw = true,
		open_on_setup = true,
		hijack_netrw = true,
		hijack_cursor = true,
		open_on_tab = true,
		view = {
			auto_resize = true,
			mappings = {
				list = list,
			},
		},
		update_focused_file = {
			enable = true,
		},
	})
end

M.setup = function()
	vim.g.nvim_tree_highlight_opened_files = 1
	vim.g.nvim_tree_refresh_wait = 500
	vim.g.nvim_tree_disable_window_picker = 1
end

return M
