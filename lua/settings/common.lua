local cmd = vim.cmd -- execute Vim commands
local exec = vim.api.nvim_exec -- execute Vimscript
local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
opt.colorcolumn = "120"
opt.scrolloff = 15
opt.cursorline = true -- Подсветка строки с курсором
opt.spelllang = { "en_us", "ru" } -- Словари рус eng
opt.number = true -- Включаем нумерацию строк
opt.relativenumber = true -- Вкл. относительную нумерацию строк
opt.undofile = true -- Возможность отката назад
opt.splitright = true -- vertical split вправо
opt.splitbelow = true -- horizontal split вниз
opt.mouse = "a"
g.mapleader = "\\"
opt.termguicolors = true --  24-bit RGB colors
opt.fileencoding = "utf-8"
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
opt.clipboard = "unnamedplus"
opt.guicursor = ""
opt.wrap = true
opt.hidden = true
opt.syntax = "enable"
g.local_vimrc = {
    names = { ".lvimrc" },
    hash_fun = "LVRHashOfFile",
}
opt.showmatch = false
opt.hlsearch = true
opt.linebreak = true
opt.bs = "indent,eol,start"
opt.fixendofline = true

-----------------------------------------------------------
-- Табы и отступы
-----------------------------------------------------------
cmd([[
filetype plugin on
filetype indent plugin on
]])
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines
opt.autoindent = true

-- don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])
cmd([[autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2]])

-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------
-- Запоминает где nvim последний раз редактировал файл
cmd([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])
-- Подсвечивает на доли секунды скопированную часть текста
exec(
    [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
augroup end
]],
    false
)

-- запуск lsp для опр типов
vim.cmd([[
    au FileType lua ++once lua require("settings.lang").lua()
    au FileType python ++once lua require("settings.lang").python()
]])

-- запоминаем fold
vim.cmd([[
set viewoptions-=options
augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* if &ft !=# 'help' | mkview | endif
    autocmd BufWinEnter *.* if &ft !=# 'help' | silent! loadview | endif
augroup END
]])

return function(m)
    nnoremap("<C-A>", "ggVG", "Vesual all")
    nnoremap("o", "o<Esc>", "Add line under")
    nnoremap("O", "O<Esc>", "Add line prev")
end
