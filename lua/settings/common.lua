local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

vim.cmd("set cc=")
opt.updatetime = 100
opt.scrolloff = 15
opt.ttyfast = true
g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell/"
opt.spell = false
opt.spelllang = { "en", "ru" }
opt.number = true
opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
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
-- allow download spell
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
opt.scrollback = 2000
opt.synmaxcol = 2000
opt.shortmess = "fFIlqx"
g.editorconfig = true
opt.clipboard = "unnamedplus"

vim.cmd([[
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

if g.neovide then
    require("settings.neovide")
end

g.root_pattern = {
    "pyproject.toml",
    "package.json",
    ".vimrc.lua",
    "Makefile",
    ".git",
    ".venv",
}
