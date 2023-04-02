local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

vim.cmd("set cc=")
opt.updatetime = 100
opt.scrolloff = 15
opt.ttyfast = true
opt.spell = false
opt.spelllang = { "en", "ru" } -- Словари рус eng
opt.number = true
opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"
opt.undofile = true -- Возможность отката назад
opt.splitright = true -- vertical split вправо
opt.splitbelow = true -- horizontal split вниз
opt.mouse = "a"
g.mapleader = "\\"
opt.termguicolors = true --  24-bit RGB colors
opt.background = "dark"
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.pumheight = 20
opt.guicursor = "a:block"
opt.wrap = true
opt.hidden = true
opt.showmatch = false
opt.hlsearch = true
opt.linebreak = true
opt.autochdir = false
opt.bs = "indent,eol,start"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
opt.scrollback = 2000
opt.synmaxcol = 1000
opt.shortmess = "fFIlqx"

-- fold
opt.foldmethod = "manual"
opt.foldcolumn = "1"
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

vim.cmd([[
syntax on
filetype plugin on
filetype indent plugin on
]])
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines
opt.autoindent = true
opt.colorcolumn = "+1"

-- completions
opt.completeopt = "menu,menuone,noselect"
opt.tags = { "tags", ".git/tags" }

if vim.g.neovide then
    require("settings.neovide")
end

vim.g.root_pattern = {
    ".vimrc.lua",
    "Makefile",
    "pyproject.toml",
    ".git",
    ".venv",
    "package.json",
}
