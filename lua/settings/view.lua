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
noremap("<leader>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")
nnoremap("<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", "Buffer: 1")
nnoremap("<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", "Buffer: 2")
nnoremap("<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", "Buffer: 3")
nnoremap("<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", "Buffer: 4")
nnoremap("<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", "Buffer: 5")
nnoremap("<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", "Buffer: 6")
nnoremap("<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", "Buffer: 7")
nnoremap("<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", "Buffer: 8")
nnoremap("<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", "Buffer: 9")

---------Tab смещение
cmd [[
vmap <S-Tab> <gv
vmap <Tab>   >gv
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

