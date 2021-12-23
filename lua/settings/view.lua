local cmd = vim.cmd 
local g = vim.g

return function(m)

---Переопрдееляем moving в vim
noremap("j", "h")
noremap("k", "j")
noremap("l", "k")
noremap(";", "l")


m.nname("<space>b", "Buffer")

--------Основное управление буферами
nnoremap("<leader>bd", "<cmd>Bdelete this<Cr>", "Buffer: delete current")
nnoremap("<leader>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")
require("buftabline").map({ prefix = "<Leader>c", cmd = "bdelete" })


---------Tab смещение
cmd [[
vmap <S-Tab>  mm<`m:<C-U>exec "normal ".&shiftwidth."h"<CR>mmgv`m
vmap <Tab>    mm>`m:<C-U>exec "normal ".&shiftwidth."l"<CR>mmgv`m
]]

---------Форматирвоание
nnoremap("<space>bf", "<cmd>Neoformat<Cr>", "Buffer: format")

--Enable alignment
g.neoformat_basic_format_align = 1
--Enable tab to spaces conversion
g.neoformat_basic_format_retab = 1
--Enable trimmming of trailing whitespace
g.neoformat_basic_format_trim = 1
g.neoformat_run_all_formatters = 1

---------Линтеры
cmd [[
call neomake#configure#automake('w')
]]
g.neomake_open_list = 2

---------Управление табами
nnoremap("<space>;", "<C-w>l", "Window: right")
nnoremap("<space><right>", "<C-w>l", "Window: right")
nnoremap("<space>k", "<C-w>j", "Window: bottom")
nnoremap("<space><down>", "<C-w>j", "Window: bottom")
nnoremap("<space>l", "<C-w>k", "Window: top")
nnoremap("<space><up>", "<C-w>k", "Window: top")
nnoremap("<space>j", "<C-w>h", "Window: left")
nnoremap("<space><left>", "<C-w>h", "Window: left")

---------Тогл Инструментов
nnoremap("<leader>f", "<Cmd>NvimTreeToggle<CR>", "FileTree: toggle")
nnoremap("<leader>n", "<Cmd>NvimTreeFindFile<CR>", "FileTree: find")
nnoremap("<leader>t", "<Cmd>Vista!!<CR>", "Tagbar")
nnoremap("<leader>g", "<Cmd>LazyGit<CR>", "LazyGit")

---------Просмотр больших файлов
cmd[[
augroup LargeFile
        let g:large_file = 10485760 " 10MB

        " Set options:
        "   eventignore+=FileType (no syntax highlighting etc
        "   assumes FileType always on)
        "   noswapfile (save copy of file)
        "   bufhidden=unload (save memory when other file is viewed)
        "   buftype=nowritefile (is read-only)
        "   undolevels=-1 (no undo possible)
        au BufReadPre *
                \ let f=expand("<afile>") |
                \ if getfsize(f) > g:large_file |
                        \ set eventignore+=FileType |
                        \ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
                        \ 
                \ else |
                        \ set eventignore-=FileType |
                \ endif
augroup END
]]



end

