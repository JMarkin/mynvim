local exec = vim.api.nvim_exec -- execute Vimscript
local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
vim.cmd("set cc=")
opt.scrolloff = 15
opt.spelllang = { "en_us", "ru" } -- Словари рус eng
opt.number = true
opt.relativenumber = false
opt.undofile = true -- Возможность отката назад
opt.splitright = true -- vertical split вправо
opt.splitbelow = true -- horizontal split вниз
opt.mouse = "a"
g.mapleader = "\\"
opt.termguicolors = true --  24-bit RGB colors
opt.fileencoding = "utf-8"
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- opt.clipboard = "unnamedplus"
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
opt.tags = {}
if vim.fn.has("nvim-0.8") == 1 then
    opt.cmdheight = 0
else
    g.do_filetype_lua = 1
    g.did_load_filetypes = 0
end

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

-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------

vim.cmd([[xnoremap <expr> p 'pgv"' . v:register . 'y']])
vim.cmd([[command! Qa :qa]])
vim.cmd([[command! Q :q]])

-- format
g.neoformat_try_formatprg = 1
g.neoformat_basic_format_align = 1
g.neoformat_basic_format_retab = 1
g.neoformat_basic_format_trim = 1
g.neoformat_run_all_formatters = 1

---------Просмотр больших файлов
vim.cmd([[
        augroup LargeFile
                let g:large_file = 10485760 " 10MB

                " Set options:
                "   eventignore+=FileType (no syntax highlighting etc
                "   assumes FileType always on)
                "   noswapfile (save copy of file)
                "   bufhidden=unload (save memory when other file is viewed)
                "   buftype=nowritefile (is read-only)
                "   undolevels=-1 (no undo possible)
                au BufReadPre *
                        \ let f=expand("<afile>") |
                        \ if getfsize(f) > g:large_file |
                                \ set eventignore+=FileType |
                                \ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
                                \
                        \ else |
                                \ set eventignore-=FileType |
                        \ endif
        augroup END
    ]])
