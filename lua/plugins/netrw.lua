local g = vim.g

g.netrw_list_hide = [[.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git]]
g.netrw_banner = 0
g.netrw_winsize = 15
g.netrw_fastbrowse = 0
g.netrw_keepdir = 1
g.netrw_sizestyle = "H"
g.netrw_preview = 1

require("netrw").setup({
    use_devicons = true,
})
