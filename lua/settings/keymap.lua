local cmd = vim.cmd

local MEM = {
    diffview = 0,
}

local lazy = require("diffview.lazy")

local diffview = lazy.require("diffview")

local format = function()
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        async = true,
    })
end

function maps(m)
    m.nname("<space>p", "Packer")
    nnoremap("<leader>ps", "<cmd>PackerSync<cr>", "Packer: sync")
    nnoremap("<leader>pc", "<cmd>PackerCompile<cr>", "Packer: compile")
    nnoremap("<leader>pi", "<cmd>PackerInstall<cr>", "Packer: install")

    --------Основное управление буферами
    m.nname("<space>b", "Buffer")

    nnoremap("<space>bd", "<cmd>Bdelete this<Cr>", "Buffer: delete current")
    nnoremap("<space>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")

    nnoremap("<space>bf", format, "silent", "Lang: lsp format")

    nnoremap(
        { "<space>l", "<space><right>", "<c-l>" },
        ":lua require('smart-splits').move_cursor_right()<cr>",
        "silent",
        "right"
    )
    nnoremap(
        { "<space>j", "<space><down>", "<c-j>" },
        ":lua require('smart-splits').move_cursor_down()<cr>",
        "silent",
        "down"
    )
    nnoremap(
        { "<space>k", "<space><up>", "<c-k>" },
        ":lua require('smart-splits').move_cursor_up()<cr>",
        "silent",
        "top"
    )
    nnoremap(
        { "<space>h", "<space><left>", "<c-h>" },
        ":lua require('smart-splits').move_cursor_left()<cr>",
        "silent",
        "left"
    )

    -- resizing splits
    nnoremap({ "<A-h>", "<space>bh" }, ':lua require("smart-splits").resize_left()<cr>', "silent", "Resize left")
    nnoremap({ "<A-j>", "<space>bj" }, ':lua require("smart-splits").resize_down()<cr>', "silent", "Resize down")
    nnoremap({ "<A-k>", "<space>bk" }, ':lua require("smart-splits").resize_up()<cr>', "silent", "Resize up")
    nnoremap({ "<A-l>", "<space>bl" }, ':lua require("smart-splits").resize_right()<cr>', "silent", "Resize right")

    nnoremap("<c-s>", "i<space><right><esc>")

    ---------Тогл Инструментов
    nnoremap("<space>f", "<Cmd>Neotree filesystem<CR>", "Neotree: filesystem")
    nnoremap("<space>t", "<Cmd>SymbolsOutline<CR>", "Tagbar")
    nnoremap("<space>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>", "Git: blame")
    nnoremap("<space>E", "<cmd>TroubleToggle workspace_diagnostics<cr>", "All Diagnostics")
    nnoremap("<space>e", "<cmd>TroubleToggle document_diagnostics<cr>", "Buffer Diagnostics")
    nnoremap("<space>v", require("lsp_lines").toggle, "silent", "Show lsp Lines")
    nnoremap("<space>T", "<Cmd>Ttoggle<CR>", "Terminal")
    nnoremap("<space>G", "<Cmd>LazyGit<CR>", "Git: lazygit")
    nnoremap("<space>D", function()
        if MEM.diffview == 0 then
            diffview.open()
            MEM.diffview = 1
        else
            diffview.close()
            MEM.diffview = 0
        end
    end, "Git: diff")

    nnoremap("<space>r", require("smart-splits").start_resize_mode, "Resize mode")

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

    vnoremap("<leader>lR", require("plugins.renamer").rename, "silent", "Lang: rename")
    nnoremap("<leader>lR", require("plugins.renamer").rename, "silent", "Lang: rename")

    nnoremap("<leader>lf", format, "silent", "Lang: lsp format")

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

    -- windows
    nnoremap("<space>w", require("nvim-window").pick, "silent", "Windows: pick")

    --save shortcut
    nnoremap("<leader>w", ":w<CR>", "silent", "normal mode: save")
    inoremap("<leader>w", "<Esc>:w<CR>l", "silent", "insert mode: escape to normal and save")
    vnoremap("<leader>w", "<Esc>:w<CR>", "visual mode: escape to normal and save")

    -- tests
    m.nname("t", "Tests")
    nnoremap("tt", '<cmd>lua require("neotest").run.run()<cr>', "Tests: run nearest test")
    nnoremap("ts", '<cmd>lua require("neotest").run.stop()<cr>', "Tests: stop nearest test")
    nnoremap("ta", '<cmd>lua require("neotest").run.attach()<cr>', "Tests: attach nearest test")
    nnoremap("tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Tests: run current file")
end

return maps
