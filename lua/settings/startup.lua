local exec = vim.api.nvim_exec

-- [[ exec([[
-- function! StartUp()
--     if argc() && isdirectory(argv()[0]) && !exists("s:std_in")
--         exe 'Alpha'
--     end
--  endfunction
--
-- autocmd StdinReadPre * let s:std_in=1
-- autocmd VimEnter * call StartUp()
-- autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
-- ]], false) ]]
