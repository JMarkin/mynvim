local cmd = vim.cmd

local MEM = {
    diffview = 0,
}

local lazy = require("diffview.lazy")

local diffview = lazy.require("diffview")

function maps(m)
    --------Основное управление буферами
    m.nname("<space>b", "Buffer")
    nnoremap("<space>bb", "<cmd>lua require('fzf-lua').buffers({ multiprocess=true})<Cr>", "Buffer: search")

    nnoremap("<space>bd", "<cmd>Bdelete this<Cr>", "Buffer: delete current")
    nnoremap("<space>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")

    nnoremap({ "<space>l", "<space><right>" }, ":lua require('smart-splits').move_cursor_right()<cr>", "right")
    nnoremap({ "<space>j", "<space><down>" }, ":lua require('smart-splits').move_cursor_down()<cr>", "down")
    nnoremap({ "<space>k", "<space><up>" }, ":lua require('smart-splits').move_cursor_up()<cr>", "top")
    nnoremap({ "<space>h", "<space><left>" }, ":lua require('smart-splits').move_cursor_left()<cr>", "left")

    -- resizing splits
    nnoremap({ "<A-h>", "<space>bh" }, ':lua require("smart-splits").resize_left()<cr>', "Resize left")
    nnoremap({ "<A-j>", "<space>bj" }, ':lua require("smart-splits").resize_down()<cr>', "Resize down")
    nnoremap({ "<A-k>", "<space>bk" }, ':lua require("smart-splits").resize_up()<cr>', "Resize up")
    nnoremap({ "<A-l>", "<space>bl" }, ':lua require("smart-splits").resize_right()<cr>', "Resize right")

    nnoremap("<c-s>", "i<space><right><esc>")

    ---------Тогл Инструментов
    nnoremap("<leader>f", "<Cmd>Neotree filesystem<CR>", "Neotree: filesystem")
    nnoremap("<leader>B", "<Cmd>Neotree buffers<CR>", "Neotree: buffers")
    nnoremap("<leader>g", "<Cmd>Neotree git_status<CR>", "Neotree: git_status")
    nnoremap("<leader>t", "<Cmd>SymbolsOutline<CR>", "Tagbar")
    nnoremap("<leader>E", require("settings.dg").open_all, "All Diagnostics")
    nnoremap("<leader>e", require("settings.dg").open_buffer, "Buffer Diagnostics")
    nnoremap("<leader>L", require("lsp_lines").toggle, "silent", "Show lsp Lines")
    nnoremap("<leader>T", "<Cmd>Ttoggle<CR>", "Terminal")
    nnoremap("<leader>G", "<Cmd>LazyGit<CR>", "Git: lazygit")
    nnoremap("<leader>D", function()
        if MEM.diffview == 0 then
            diffview.open()
            MEM.diffview = 1
        else
            diffview.close()
            MEM.diffview = 0
        end
    end, "Git: diff")

    --- GIT
    nnoremap("<space>b", "<Cmd>Gitsigns toggle_current_line_blame<CR>", "Git: blame")
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
    nnoremap("zf", "<cmd>setl fdm&<CR>zf", "Create fold")
    xnoremap("zf", "<cmd>setl fdm&<CR>zf", "Create fold")

    ---- Перемещения
    nnoremap("J", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>", "half down")
    nnoremap("K", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>", "half up")

    ---search
    m.nname("<leader>s", "Search")

    nnoremap("<leader>sq", "<cmd>lua require('fzf-lua').quickfix({ multiprocess=true})<Cr>", "Search: quickfix")
    nnoremap("<leader>sl", "<cmd>lua require('fzf-lua').loclist({ multiprocess=true})<Cr>", "Search: loclist")
    nnoremap("<leader>ss", "<cmd>lua require('fzf-lua').resume({ multiprocess=true})<Cr>", "Search: previous")
    nnoremap("<leader>sb", "<cmd>lua require('fzf-lua').buffers({ multiprocess=true})<Cr>", "Search: buffers")
    nnoremap("<leader>sB", "<cmd>lua require('plugins.bookmark').search()<Cr>", "Search: bookmark")
    nnoremap("<leader>sf", "<cmd>lua require('fzf-lua').files({ multiprocess=true,})<Cr>", "Search: find files")
    nnoremap(
        "<leader>sg",
        "<cmd>lua require('fzf-lua').grep_project({  multiprocess=true,continue_last_search = true })<Cr>",
        "Search: project"
    )
    nnoremap(
        "<leader>s/",
        "<cmd>lua require('fzf-lua').lgrep_curbuf({ multiprocess=true,})<Cr>",
        "Search: current buffer"
    )
    nnoremap(
        "<leader>st",
        "<cmd>lua require('fzf-lua').tags({ multiprocess=true,ctags_file=vim.opt.tags._value})<Cr>",
        "Search: tags"
    )
    nnoremap(
        "<leader>sd",
        "<cmd>lua require('fzf-lua').lsp_definitions({ multiprocess=true,})<Cr>",
        "Search: Definitions"
    )
    nnoremap("<leader>sc", "<cmd>lua require('fzf-lua').commands({ multiprocess=true,})<Cr>", "Search: commands")
    nnoremap("<leader>sk", "<cmd>lua require('fzf-lua').keymaps({ multiprocess=true,})<Cr>", "Search: keymaps")
    nnoremap(
        "<leader>sch",
        "<cmd>lua require('fzf-lua').command_history({ multiprocess=true,})<Cr>",
        "Search: command_history"
    )

    ---go to
    nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "GoTo: definition")
    nnoremap(
        "gr",
        "<cmd>lua require('fzf-lua').lsp_references({ multiprocess=true,})<Cr>",
        "silent",
        "GoTo: references"
    )

    -- lang
    m.nname("<leader>l", "Language features")
    nnoremap("<leader>lD", "<cmd>Neogen<cr>", "silent", "Lang: generete docs")

    nnoremap("<leader>la", "<cmd>CodeActionMenu<cr>", "silent", "Lang: code action")

    if vim.fn.has("nvim-0.8") == 1 then
        vim.keymap.set("n", "<leader>lR", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Lang: rename" })
        vim.keymap.set("v", "<leader>lR", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Lang: rename" })
    else
        vnoremap("<leader>lR", "<cmd>lua require('renamer').rename()<cr>", "silent", "Lang: rename")
        nnoremap("<leader>lR", "<cmd>lua require('renamer').rename()<cr>", "silent", "Lang: rename")
    end
    nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", "silent", "Lang: lsp format")
    vnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", "silent", "Lang: lsp format")

    -- DEBUG
    m.nname("<leader>d", "Debug")
    nnoremap("<leader>dt", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", "silent")
    nnoremap("<leader>dc", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", "silent")
    nnoremap("<leader>dda", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", "silent")

    -- Visual
    nnoremap("<C-A>", "ggVG", "Visual all")
    nnoremap("o", "o<Esc>", "Add line under")
    nnoremap("O", "O<Esc>", "Add line prev")

    -- Bookmark
    m.nname("<leader>b", "Bookmark")

    nnoremap("<leader>bb", "<Plug>BookmarkToggle", "Bookmark: Toggle")
    nnoremap("<leader>bi", "<Plug>BookmarkAnnotate", "Bookmark: Annotate")
    nnoremap("<leader>ba", "<Plug>BookmarkShowAll", "Bookmark: ShowAll")
    nnoremap("<leader>bj", "<Plug>BookmarkNext", "Bookmark: Next")
    nnoremap("<leader>bk", "<Plug>BookmarkPrev", "Bookmark: Prev")
    nnoremap("<leader>bc", "<Plug>BookmarkClear", "Bookmark: Clear")
    nnoremap("<leader>bx", "<Plug>BookmarkClearAll", "Bookmark: ClearAll")
    nnoremap("<leader>bkk", "<Plug>BookmarkMoveUp", "Bookmark: MoveUp")
    nnoremap("<leader>bjj", "<Plug>BookmarkMoveDown", "Bookmark: MoveDown")
    nnoremap("<leader>bg", "<Plug>BookmarkMoveToLine", "Bookmark: MoveToLine")

    -- CLipboard OSC52
    vim.keymap.set("n", "<leader>c", require("osc52").copy_operator, { expr = true })
    vim.keymap.set("n", "<leader>cc", "<leader>c_", { remap = true })
    vim.keymap.set("x", "<leader>c", require("osc52").copy_visual)
    vim.keymap.set("n", "<leader>y", require("osc52").copy_operator, { expr = true })
    vim.keymap.set("n", "<leader>yy", "<leader>y_", { remap = true })
    vim.keymap.set("x", "<leader>y", require("osc52").copy_visual)

    -- qf loclist
    nnoremap("<leader>lo", "<cmd>lua require'qf'.open('l')<CR>", "Open location list")
    nnoremap("<leader>lc", "<cmd>lua require'qf'.close('l')<CR>", " Close location list")
    nnoremap(
        "<leader>ll",
        "<cmd>lua require'qf'.toggle('l', true)<CR>",
        "Toggle location list and stay in current window"
    )

    nnoremap("<leader>co", "<cmd>lua require'qf'.open('c')<CR>", "Open quickfix list")
    nnoremap("<leader>cc", "<cmd>lua require'qf'.close('c')<CR>", "Close quickfix list")
    nnoremap(
        "<leader>cl",
        "<cmd>lua require'qf'.toggle('c', true)<CR>",
        "Toggle quickfix list and stay in current window"
    )

    nnoremap("]l", "<cmd>lua require'qf'.below('l')<CR>", "Go to next location list entry from cursor")
    nnoremap("[l", "<cmd>lua require'qf'.above('l')<CR>", "Go to previous location list entry from cursor")

    nnoremap("]q", "<cmd>lua require'qf'.below('c')<CR>", "Go to next quickfix entry from cursor")
    nnoremap("[q", "<cmd>lua require'qf'.above('c')<CR>", "Go to previous quickfix entry from cursor")

    nnoremap("]e", "<cmd>lua require'qf'.below('visible')<CR>", "Go to next entry from cursor in visible list")
    nnoremap("[e", "<cmd>lua require'qf'.above('visible')<CR>", "Go to previous entry from cursor in visible list")

    -- todo
    vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
end

return maps
