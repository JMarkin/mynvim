local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
vim.cmd("set cc=")
opt.updatetime = 100
opt.scrolloff = 15
opt.spell = false
opt.spelllang = { "en", "ru" } -- Словари рус eng
opt.number = true
opt.relativenumber = false
opt.undofile = true -- Возможность отката назад
opt.splitright = true -- vertical split вправо
opt.splitbelow = true -- horizontal split вниз
opt.mouse = "a"
g.mapleader = "\\"
opt.termguicolors = true --  24-bit RGB colors
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
opt.guicursor = "a:block"
opt.wrap = true
opt.hidden = true
opt.syntax = "enable"
opt.showmatch = false
opt.hlsearch = true
opt.linebreak = true
opt.bs = "indent,eol,start"
opt.tags = {}
if vim.fn.has("nvim-0.8") ~= 1 then
    g.do_filetype_lua = 1
    g.did_load_filetypes = 0
end

-- fold
opt.foldmethod = "manual"
opt.foldcolumn = "1"
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

-----------------------------------------------------------
-- Табы и отступы
-----------------------------------------------------------
vim.cmd([[
filetype plugin on
filetype indent plugin on
]])
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines
opt.autoindent = true

vim.cmd([[xnoremap <expr> p 'pgv"' . v:register . 'y']])
