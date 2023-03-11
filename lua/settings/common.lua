local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
vim.cmd("set cc=")
opt.updatetime = 100
opt.scrolloff = 15
opt.ttyfast = true
opt.spell = false
opt.spelllang = { "en", "ru" } -- Словари рус eng
opt.number = true
opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"
opt.relativenumber = false
opt.undofile = true -- Возможность отката назад
opt.splitright = true -- vertical split вправо
opt.splitbelow = true -- horizontal split вниз
opt.mouse = "a"
g.mapleader = "\\"
opt.termguicolors = true --  24-bit RGB colors
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.pumheight = 20
opt.guicursor = "a:block"
opt.wrap = false
opt.hidden = true
opt.syntax = "enable"
opt.showmatch = false
opt.hlsearch = true
opt.linebreak = true
opt.autochdir = false
opt.bs = "indent,eol,start"
if vim.fn.has("nvim-0.8") ~= 1 then
    g.do_filetype_lua = 1
    g.did_load_filetypes = 0
end
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- completions
opt.completeopt = "menu,menuone,noselect"
opt.tags = { "tags", ".git/tags" }

if vim.g.neovide then
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
    vim.keymap.set("v", "<D-c>", '"+y') -- Copy
    vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end
