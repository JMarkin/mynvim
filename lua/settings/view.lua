local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

vim.opt.list = false
-- vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("multispace:¦   ")
vim.opt.listchars:append("eol:↴")

return function(m)
    ---Переопрдееляем moving в vim
    -- noremap("j", "h")
    -- noremap("k", "j")
    -- noremap("l", "k")
    -- noremap(";", "l")

    m.nname("<space>b", "Buffer")

    --------Основное управление буферами
    nnoremap("<space>bd", "<cmd>Bdelete this<Cr>", "Buffer: delete current")
    nnoremap("<space>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")
    nnoremap("<space>1", "<Cmd>BufferLineGoToBuffer 1<CR>", "Buffer: 1")
    nnoremap("<space>2", "<Cmd>BufferLineGoToBuffer 2<CR>", "Buffer: 2")
    nnoremap("<space>3", "<Cmd>BufferLineGoToBuffer 3<CR>", "Buffer: 3")
    nnoremap("<space>4", "<Cmd>BufferLineGoToBuffer 4<CR>", "Buffer: 4")
    nnoremap("<space>5", "<Cmd>BufferLineGoToBuffer 5<CR>", "Buffer: 5")
    nnoremap("<space>6", "<Cmd>BufferLineGoToBuffer 6<CR>", "Buffer: 6")
    nnoremap("<space>7", "<Cmd>BufferLineGoToBuffer 7<CR>", "Buffer: 7")
    nnoremap("<space>8", "<Cmd>BufferLineGoToBuffer 8<CR>", "Buffer: 8")
    nnoremap("<space>9", "<Cmd>BufferLineGoToBuffer 9<CR>", "Buffer: 9")

    nnoremap({ "<leader>w", "<space>w" }, "<cmd>:lua require('nvim-window').pick()<CR>", "Pick Window")

    ---------Управление буферами
    nnoremap({ "<space>l", "<space><right>" }, ":lua require('smart-splits').move_cursor_right()<cr>", "right")
    nnoremap({ "<space>j", "<space><down>" }, ":lua require('smart-splits').move_cursor_down()<cr>", "down")
    nnoremap({ "<space>k", "<space><up>" }, ":lua require('smart-splits').move_cursor_up()<cr>", "top")
    nnoremap({ "<space>h", "<space><left>" }, ":lua require('smart-splits').move_cursor_left()<cr>", "left")
    -- resizing splits
    nnoremap({ "<A-h>", "<space>bh" }, ':lua require("smart-splits").resize_left()<cr>', "Resize left")
    nnoremap({ "<A-j>", "<space>bj" }, ':lua require("smart-splits").resize_down()<cr>', "Resize down")
    nnoremap({ "<A-k>", "<space>bk" }, ':lua require("smart-splits").resize_up()<cr>', "Resize up")
    nnoremap({ "<A-l>", "<space>bl" }, ':lua require("smart-splits").resize_right()<cr>', "Resize right")

    ---------Tab смещение
    vmap("<S-Tab>", "<gv")
    vmap("<Tab>", ">gv")

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
    -- cmd [[
    -- call neomake#configure#automake('w')
    -- ]]
    -- g.neomake_open_list = 2

    ---------Тогл Инструментов
    nnoremap("<leader>f", "<Cmd>NvimTreeToggle<CR>", "FileTree: open")
    nnoremap("<leader>t", "<Cmd>Vista!!<CR>", "Tagbar")
    nnoremap("<leader>e", "<Cmd>Trouble<CR>", "Trouble")

    m.nname("<space>g", "Git")
    nnoremap("<leader>gg", "<Cmd>LazyGit<CR>", "Git: lazygit")
    nnoremap("<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", "Git: blame")
    cmd([[highlight link GitSignsCurrentLineBlame Insert]])

    ---------Просмотр больших файлов
    cmd([[
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
    ]])

    ---- Fold
    m.nname("z", "Fold")
    m.nname("<space>f", "Fold")
    nmap("<space>fb", "zf]%", "Fold expr block")
end
