local g = vim.g     -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

if vim.env.PYTHON3 then
    g.python3_host_prog = vim.env.PYTHON3
end

g.snips_author = vim.env.AUTHOR or "Jury Markin"
g.snips_email = vim.env.EMAIL or "me@jmarkin.ru"
g.snips_github = vim.env.EMAIL or "https://github.com/JMarkin"
g.loaded_matchit = 1
vim.cmd [[language C]]
g.cursorhold_updatetime = 100
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
g.editorconfig = true
opt.clipboard = "unnamedplus"
opt.exrc = true

vim.cmd([[
filetype plugin on
filetype indent plugin on
]])
opt.expandtab = true   -- use spaces instead of tabs
opt.shiftwidth = 4     -- shift 4 spaces when tab
opt.tabstop = 4        -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines
opt.autoindent = true
opt.colorcolumn = "+1"

opt.autowrite = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- completions
opt.completeopt = "menu,menuone,noselect"
opt.tags = { "tags", ".git/tags" }

g.root_pattern = {
    "pyproject.toml",
    "package.json",
    ".nvim.lua",
    "Makefile",
    ".git",
    ".venv",
}

-- fast dirs
local ramdisk = vim.fn.expand("~/RAMDisk")
if vim.fn.isdirectory(ramdisk) then
    ramdisk = ramdisk .. "/nvim/"
    opt.dir = ramdisk .. "swap"
    opt.shadafile = ramdisk .. "shada/main.shada"
end
