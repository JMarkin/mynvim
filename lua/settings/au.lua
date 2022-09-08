-- don't auto commenting new lines
local disable_auto_comment = "DisableAutoComment"
vim.api.nvim_create_augroup(disable_auto_comment, { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    group = disable_auto_comment,
    pattern = { "*" },
    command = "set fo-=c fo-=r fo-=o",
})

-- Запоминает где nvim последний раз редактировал файл
local last_change = "LastChange"
vim.api.nvim_create_augroup(last_change, { clear = true })

local function save_last_change()
    vim.cmd(
        [[if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]]
    )
end
vim.api.nvim_create_autocmd("BufReadPost", {
    group = last_change,
    pattern = { "*" },
    callback = save_last_change,
})

-- Подсвечивает на доли секунды скопированную часть текста
local yank_hightlight = "YankHighlight"
vim.api.nvim_create_augroup(yank_hightlight, { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = yank_hightlight,
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- синхронизация между инстансами
local sync_neovim = "SHADA"
vim.api.nvim_create_augroup(sync_neovim, { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold", "TextYankPost", "FocusGained", "FocusLost" }, {
    group = yank_hightlight,
    pattern = { "*" },
    callback = function()
        vim.cmd([[if exists(':rshada') | rshada | wshada | endif]])
    end,
})

--- загрузка брекпоинтов
vim.api.nvim_create_autocmd({ "BufReadPost" }, { callback = require("persistent-breakpoints.api").load_breakpoints })

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
    command = "silent! loadview",
    group = save_fold,
    desc = "Load view on entering buffer",
})

--- диагностики
local diagnostics = "Diagnostics"
vim.api.nvim_create_augroup(diagnostics, { clear = true })
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    pattern = "*.*",
    group = diagnostics,
    callback = require("settings.dg").sync_all,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = "*.*",
    group = diagnostics,
    callback = require("settings.dg").sync_buffer,
})
