-- don't auto commenting new lines
vim.cmd([[
augroup DisableAutoComment
    au!
    au BufEnter * set fo-=c fo-=r fo-=o
augroup END
]])

-- Запоминает где nvim последний раз редактировал файл
vim.cmd([[
augroup LastChange
    au!
    autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
augroup END
]])

-- Подсвечивает на доли секунды скопированную часть текста
vim.cmd([[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
augroup end
]])

vim.cmd([[
augroup SHADA
    autocmd!
    autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
                \ if exists(':rshada') | rshada | wshada | endif
augroup END
]])
