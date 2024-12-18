local g = vim.g
local opt = vim.opt

g.has_ui = #vim.api.nvim_list_uis() > 0
g.modern_ui = (g.has_ui and vim.env.DISPLAY ~= nil) or string.format("%s", vim.env.TERM):find("256")
vim.g.post_load_events = { "BufReadPost", "FileReadPost", "TermOpen" }
vim.g.pre_load_events = { "BufReadPre", "FileReadPre", "BufNewFile", "TermOpen" }

-- stylua: ignore start
opt.shell                             = 'sh'
g.snips_author                        = vim.env.AUTHOR or "Jury Markin"
g.snips_email                         = vim.env.EMAIL or "me@jmarkin.ru"
g.snips_github                        = vim.env.GITHUB or "https://github.com/JMarkin"
opt.colorcolumn                       = '+1'
opt.cursorlineopt                     = 'both'
opt.cursorline                        = true
g.cursorhold_updatetime               = 100
opt.foldlevelstart                    = 99
opt.winwidth                          = 20
opt.winminwidth                       = 20
opt.pumheight                         = 20
opt.splitright                        = true
opt.splitbelow                        = true
opt.equalalways                       = false
opt.updatetime                        = 100
opt.mousemoveevent                    = true
opt.number                            = true
g.numbertoggle                        = true
opt.ruler                             = true
opt.scrolloff                         = 4
opt.sidescrolloff                     = 8
opt.sidescroll                        = 0
opt.signcolumn                        = 'yes:1'
opt.swapfile                          = true
opt.undofile                          = true
opt.wrap                              = false
opt.linebreak                         = true
opt.breakindent                       = true
opt.scrollback                        = 2000
opt.conceallevel                      = 0
opt.autowriteall                      = true
opt.virtualedit                       = 'block'
opt.mouse                             = "a"
g.mapleader                           = "\\"
opt.fileencoding                      = "utf-8"
opt.encoding                          = "utf-8"
opt.hidden                            = true
opt.showmatch                         = false
opt.hlsearch                          = true
opt.autochdir                         = false
opt.bs                                = "indent,eol,start"
g.editorconfig                        = true
opt.synmaxcol                         = 2000
opt.exrc                              = true
opt.grepformat                        = "%f:%l:%c:%m"
opt.grepprg                           = "rg --vimgrep"

opt.guifont                           = "JetBrainsMonoNL Nerd Font Mono:h13"
opt.guicursor                         = "a:block"
opt.background                        = "dark"

opt.completeopt                       = "menu,menuone,noselect"
opt.tags                              = { "tags", ".git/tags" }

opt.spell                             = false
opt.spelllang                         = { "en", "ru" }
g.spellfile_URL                       = "https://ftp.nluug.nl/vim/runtime/spell/"

g.root_pattern                        = {
                                            "pyproject.toml",
                                            "package.json",
                                            "Cargo.toml",
                                            ".nvim.lua",
                                            "Makefile",
                                            ".git",
                                            ".venv",
                                        }
opt.list                              = true
opt.listchars                         = {
                                          tab     = '→ ',
                                          trail   = '·',
                                          eol     = '↲',
                                        }
opt.fillchars                         = {
                                          fold    = '·',
                                          foldsep = ' ',
                                          eob     = ' ',
                                        }

opt.tabstop                           = 4
opt.softtabstop                       = 4
opt.shiftwidth                        = 4
opt.expandtab                         = true
opt.smartindent                       = true
opt.autoindent                        = true

opt.ignorecase                        = true
opt.smartcase                         = true

opt.termguicolors                     = true

opt.textwidth                         = 80

opt.relativenumber                    = true
opt.sessionoptions                    = 'curdir,folds,globals,help,tabpages,terminal,winsize'

g.omni_sql_ignorecase                 = 1


g.ollama_host                         = vim.env.OLLAMA_HOST or "localhost"
g.ollama_port                         = vim.env.OLLAMA_PORT or "11434"
g.ollama_url                          = string.format("http://%s:%s", g.ollama_host, g.ollama_port)
g.ollama_generate_endpoint            = string.format("%s/api/generate", g.ollama_url)
g.ollama_chat_endpoint                = string.format("%s/api/chat", g.ollama_url)


g.lsp_autostart                       = false

-- stylua: ignore end

-- opt.clipboard:append("unnamedplus")
opt.shortmess:append({ W = false, I = true, c = true, C = true, A = false })

if g.modern_ui then
    opt.listchars:append({ nbsp = "␣" })
    opt.fillchars:append({
        foldopen = "",
        foldclose = "",
        diff = "╱",
    })
end

if not vim.g.modern_ui then
    opt.termguicolors = false
end

if vim.fn.executable("bash") then
    opt.shell = "bash"
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
vim.api.nvim_create_autocmd("FileReadPre", { once = true, callback = _rshada })

opt.backup = true
opt.backupdir:remove(".")

-- netrw settings
-- stylua: ignore start
g.netrw_winsize         = 20
g.netrw_banner          = 0
g.netrw_cursor          = 5
g.netrw_keepdir         = 1
g.netrw_list_hide       = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle       = 0
g.netrw_localcopydircmd = "cp -r"
g.netrw_preview         = 1
g.netrw_alto            = 1
g.netrw_fastbrowse      = 2
-- stylua: ignore end

-- disable plugins shipped with neovim
-- g.loaded_2html_plugin = 1
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

g.linter_by_ft = {
    sql = { "codespell", "sqlfluff" },
    jinja = { "djlint" },
    htmldjango = { "djlint" },
    python = { "codespell", "mypy" },
    rust = { "codespell" },
}

g.formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    json = { "fixjson" },
    jinja = { "djlint" },
    htmldjango = { "djlint" },
}

for _, lang in ipairs({
    "javascript",
    "typescript",
    "jsx",
    "tsx",
    "jsonc",
}) do
    g.formatters_by_ft[lang] = { "biome" }
end
for _, lang in ipairs({
    "markdown",
    "html",
    "css",
    "yaml",
    "scss",
    "vue",
}) do
    g.formatters_by_ft[lang] = { "prettier" }
end
