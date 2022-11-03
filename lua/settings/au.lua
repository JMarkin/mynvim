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

-- синхронизация между инстансами
local sync_neovim = "SHADA"
vim.api.nvim_create_augroup(sync_neovim, { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold", "TextYankPost", "FocusGained", "FocusLost" }, {
    group = sync_neovim,
    pattern = { "*" },
    callback = function()
        vim.cmd([[if exists(':rshada') | rshada | wshada | endif]])
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
    command = "silent! loadview",
    group = save_fold,
    desc = "Load view on entering buffer",
})

-- lsp init
local lsp_init = "LspInit"
vim.api.nvim_create_augroup(lsp_init, { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
    group = lsp_init,
    pattern = { "*" },
    callback = require("settings.lang").config,
})

---------Просмотр больших файлов
local large_files = "LargeFiles"
vim.api.nvim_create_augroup(large_files, { clear = true })

local max_file_size = 5242880 -- 5MB
local max_file_size_readonly = 10485760 -- 10MB
local disable_filetype = false

vim.api.nvim_create_autocmd("BufReadPre", {
    group = large_files,
    pattern = { "*" },
    callback = function()
        local file = vim.fn.expand("%:p")
        if file == nil or #file == 0 then
            if disable_filetype then
                vim.opt.eventignore:remove({ "FileType" })
            end
            return
        end
        local size = vim.fn.getfsize(file)
        if size > max_file_size then
            vim.opt.eventignore:append({ "FileType" })
            vim.opt_local.noswapfile = true
            vim.opt_local.bufhidden = "unload"
            vim.opt_local.wrap = false
            vim.opt_local.syntax = "disable"
            vim.opt_local.wrap = false
            vim.opt_local.spell = false

            if size > max_file_size_readonly then
                vim.opt_local.buftype = "nowrite"
                vim.opt_local.undolevels = -1
                vim.opt_local.undofile = false
                vim.opt_local.lazyredraw = true
            end
            disable_filetype = true
        else
            vim.opt.eventignore:remove({ "FileType" })
            disable_filetype = false
        end
    end,
})

-- filetype textwidth colorcolumn
local ft_width = "FTWidth"
vim.api.nvim_create_augroup(ft_width, { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = ft_width,
    pattern = { "python" },
    callback = function(opts)
        local max_line = vim.g.python_max_line or 120
        vim.opt_local.textwidth = max_line
        vim.opt_local.colorcolumn = '+1'
    end,
})

--matchup custom
local matchup_words = "MatchUpWords"
vim.api.nvim_create_augroup(matchup_words, {clear=true})
-- vim.api.nvim_create_autocmd("FileType", {
--     group = matchup_words,
--     pattern = {"css", "javascript", "typescript", "cpp", "c"},
--     command = "call matchup#util#append_match_words('\/\*:\*\/')",
-- })
