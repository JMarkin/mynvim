vim.opt.list = true
vim.g.indent_blankline_use_treesitter = true

require("indent_blankline").setup({
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
})
