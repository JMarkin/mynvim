-- синхронизация между инстансами
local sync_neovim = "SHADA"
vim.api.nvim_create_augroup(sync_neovim, { clear = true })

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = sync_neovim,
    pattern = { "*" },
    callback = function()
        vim.cmd([[if exists(':rshada /tmp/shada') | rshada /tmp/shada | wshada /tmp/shada | endif]])
    end,
})

--- сохранение fold
local save_fold = "PersistentFold"
vim.api.nvim_create_augroup(save_fold, { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    command = "mkview",
    group = save_fold,
    desc = "Save view on leaving buffer",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    command = "silent loadview",
    group = save_fold,
    desc = "Load view on entering buffer",
})

--matchup custom
-- local matchup_words = "MatchUpWords"
-- vim.api.nvim_create_augroup(matchup_words, { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--     group = matchup_words,
--     pattern = {"css", "javascript", "typescript", "cpp", "c"},
--     command = "call matchup#util#append_match_words('\/\*:\*\/')",
-- })

local fzf = "FZF"
vim.api.nvim_create_augroup(fzf, { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    group = fzf,
    command = 'lua require("fzf-lua").redraw()',
})

local enable_syntax = "ENABLE_SYNTAX"
vim.api.nvim_create_augroup(enable_syntax, { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "mako",
        "yaml.ansible",
        "applescript",
        "caddyfile",
        "csv",
        "glsl",
        "graphql",
        "haproxy",
        "helm",
        "mako",
        "nginx",
        "rst",
        "svg",
        "systemd",
        "xml",
        "log",
    },
    group = enable_syntax,
    callback = function()
        vim.opt.omnifunc = "syntaxcomplete#Complete"
    end,
})
