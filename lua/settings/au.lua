-- синхронизация между инстансами
local sync_neovim = "SHADA"
vim.api.nvim_create_augroup(sync_neovim, { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold", "TextYankPost" }, {
    group = sync_neovim,
    pattern = { "*" },
    callback = function()
        vim.cmd([[if exists(':rshada /tmp/shada') | rshada /tmp/shada | wshada /tmp/shada | endif]])
    end,
})
-- Запоминает где nvim последний раз редактировал файл
local last_change = "LastChange"
vim.api.nvim_create_augroup(last_change, { clear = true })

local function save_last_change()
    vim.cmd(
        [[if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" |
        endif ]]
    )
end
vim.api.nvim_create_autocmd("BufReadPost", {
    group = last_change,
    pattern = { "*.*" },
    callback = save_last_change,
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

-- filetype textwidth colorcolumn
local ft_width = "FTWidth"
vim.api.nvim_create_augroup(ft_width, { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = ft_width,
    pattern = { "python", "lua" },
    callback = function(_)
        local max_line = vim.g.python_max_line or 120
        vim.opt_local.textwidth = max_line
        vim.opt_local.colorcolumn = "+1"
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    group = ft_width,
    pattern = { "netrw" },
    callback = function(_)
        vim.opt_local.textwidth = 15
    end,
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

-- fix lvimrc
local lvimrc = "lvimrc"
vim.api.nvim_create_augroup(lvimrc, { clear = true })
local loaded = 0
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    group = lvimrc,
    callback = function()
        if loaded == 0 then
            require("config-local").source()
            loaded = 1
        end
    end,
})
