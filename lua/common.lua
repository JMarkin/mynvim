-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

local g = vim.g
local opt = vim.opt

g.has_ui = #vim.api.nvim_list_uis() > 0
g.modern_ui = (g.has_ui and vim.env.DISPLAY ~= nil) or string.format("%s", vim.env.TERM):find("256")

if vim.fn.executable("bash") then
    opt.shell = "bash"
end
-- stylua: ignore start
g.snips_author              = vim.env.AUTHOR or "Jury Markin"
g.snips_email               = vim.env.EMAIL or "me@jmarkin.ru"
g.snips_github              = vim.env.GITHUB or "https://github.com/JMarkin"
opt.colorcolumn             = '+1'
opt.cursorlineopt           = 'both'
opt.cursorline              = true
g.cursorhold_updatetime     = 100
opt.foldlevelstart          = 99
opt.winwidth                = 20
opt.winminwidth             = 20
opt.pumheight               = 20
opt.splitright              = true
opt.splitbelow              = true
opt.equalalways             = false
opt.updatetime              = 100
opt.mousemoveevent          = true
opt.number                  = true
opt.ruler                   = true
opt.scrolloff               = 4
opt.sidescrolloff           = 8
opt.sidescroll              = 0
opt.signcolumn              = 'yes:1'
opt.swapfile                = true
opt.undofile                = true
opt.wrap                    = false
opt.linebreak               = true
opt.breakindent             = true
opt.scrollback              = 2000
opt.conceallevel            = 0
opt.autowriteall            = true
opt.virtualedit             = 'block'
opt.ttyfast                 = true
opt.mouse                   = "a"
g.mapleader                 = "\\"
opt.fileencoding            = "utf-8"
opt.encoding                = "utf-8"
opt.hidden                  = true
opt.showmatch               = false
opt.hlsearch                = true
opt.autochdir               = false
opt.bs                      = "indent,eol,start"
g.editorconfig              = true
opt.synmaxcol               = 2000
opt.exrc                    = true
opt.grepformat              = "%f:%l:%c:%m"
opt.grepprg                 = "rg --vimgrep"

opt.guifont                 = "JetBrainsMonoNL Nerd Font Mono:h13"
opt.guicursor               = "a:block"
opt.background              = "dark"

opt.completeopt             = "menu,menuone,noselect"
opt.tags                    = { "tags", ".git/tags" }
opt.tagfunc                 = nil
g.omni_sql_no_default_maps  = true
opt.omnifunc                = "syntaxcomplete#Complete"

opt.spell                   = false
opt.spelllang               = { "en", "ru" }
g.spellfile_URL             = "https://ftp.nluug.nl/vim/runtime/spell/"

g.root_pattern              = {
                                "pyproject.toml",
                                "package.json",
                                "Cargo.toml",
                                ".nvim.lua",
                                "Makefile",
                                ".git",
                                ".venv",
                            }
opt.list                    = true
opt.listchars               = {
                              tab      = '→ ',
                              trail    = '·',
                            }
opt.fillchars               = {
                              fold      = '·',
                              foldsep   = ' ',
                              eob       = ' ',
                            }

opt.tabstop                 = 4
opt.softtabstop             = 4
opt.shiftwidth              = 4
opt.expandtab               = true
opt.smartindent             = true
opt.autoindent              = true

opt.ignorecase              = true
opt.smartcase               = true

opt.termguicolors           = true

opt.textwidth               = 120

-- stylua: ignore end

opt.clipboard:append("unnamedplus")
opt.formatoptions:append("n")
opt.shortmess:append({ W = false, I = true, c = true, C = true, A = false })

if g.modern_ui then
    opt.listchars:append({ nbsp = "␣" })
    opt.fillchars:append({
        foldopen = "",
        foldclose = "",
        diff = "╱",
    })
end

vim.cmd([[
filetype plugin on
filetype indent plugin on
]])

if not vim.g.modern_ui then
    opt.termguicolors = false
end

---Restore 'shada' option and read from shada once
---@return true
local function _rshada()
    if not vim.g._shada_read then
        vim.cmd.set("shada&")
        vim.cmd.rshada()
        vim.g._shada_read = true
    end
    return true
end

opt.shada = ""
vim.defer_fn(_rshada, 100)
vim.api.nvim_create_autocmd("BufReadPre", { once = true, callback = _rshada })

opt.backup = true
opt.backupdir:remove(".")

-- netrw settings
g.netrw_banner = 0
g.netrw_cursor = 5
g.netrw_keepdir = 0
g.netrw_keepj = ""
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle = 1
g.netrw_localcopydircmd = "cp -r"

-- disable plugins shipped with neovim
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0


-- g.loaded_zip = 1
-- g.loaded_zipPlugin = 1
-- g.loaded_gzip = 1
-- g.loaded_tar = 1
-- g.loaded_tarPlugin = 1
-- stylua: ignore end
