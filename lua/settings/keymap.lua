local cmd = vim.cmd

local MEM = {
    diffview = 0,
}

local lazy = require("diffview.lazy")

local diffview = lazy.require("diffview")

local format = function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls" or client.name == "rust_analyzer"
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

    nnoremap({ "<space><right>", "<c-l>" }, ":lua require('smart-splits').move_cursor_right()<cr>", "silent", "right")
    nnoremap({ "<space><down>", "<c-j>" }, ":lua require('smart-splits').move_cursor_down()<cr>", "silent", "down")
    nnoremap({ "<space><up>", "<c-k>" }, ":lua require('smart-splits').move_cursor_up()<cr>", "silent", "top")
    nnoremap({ "<space><left>", "<c-h>" }, ":lua require('smart-splits').move_cursor_left()<cr>", "silent", "left")

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

    -- Half-window movements:
    vim.keymap.set({ "n", "x" }, "<C-u>", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<C-d>", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "J", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "K", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")

    -- Page movements:
    vim.keymap.set({ "n", "x" }, "<C-b>", "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<C-f>", "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<PageUp>", "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<PageDown>", "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>")

    -- EXTRA_KEYMAPS:

    -- Start/end of file and line number movements:
    vim.keymap.set({ "n", "x" }, "gg", "<Cmd>lua Scroll('gg')<CR>")
    vim.keymap.set({ "n", "x" }, "G", "<Cmd>lua Scroll('G', 0, 1)<CR>")

    -- Paragraph movements:
    vim.keymap.set({ "n", "x" }, "{", "<Cmd>lua Scroll('{')<CR>")
    vim.keymap.set({ "n", "x" }, "}", "<Cmd>lua Scroll('}')<CR>")

    -- Previous/next search result:
    vim.keymap.set("n", "n", "<Cmd>lua Scroll('n', 1)<CR>")
    vim.keymap.set("n", "N", "<Cmd>lua Scroll('N', 1)<CR>")
    vim.keymap.set("n", "*", "<Cmd>lua Scroll('*', 1)<CR>")
    vim.keymap.set("n", "#", "<Cmd>lua Scroll('#', 1)<CR>")
    vim.keymap.set("n", "g*", "<Cmd>lua Scroll('g*', 1)<CR>")
    vim.keymap.set("n", "g#", "<Cmd>lua Scroll('g#', 1)<CR>")

    -- Previous/next cursor location:
    vim.keymap.set("n", "<C-o>", "<Cmd>lua Scroll('<C-o>', 1)<CR>")
    vim.keymap.set("n", "<C-i>", "<Cmd>lua Scroll('1<C-i>', 1)<CR>")

    -- Screen scrolling:
    vim.keymap.set("n", "zz", "<Cmd>lua Scroll('zz', 0, 1)<CR>")
    vim.keymap.set("n", "zt", "<Cmd>lua Scroll('zt', 0, 1)<CR>")
    vim.keymap.set("n", "zb", "<Cmd>lua Scroll('zb', 0, 1)<CR>")
    vim.keymap.set("n", "z.", "<Cmd>lua Scroll('z.', 0, 1)<CR>")
    vim.keymap.set("n", "z<CR>", "<Cmd>lua Scroll('zt^', 0, 1)<CR>")
    vim.keymap.set("n", "z-", "<Cmd>lua Scroll('z-', 0, 1)<CR>")
    vim.keymap.set("n", "z^", "<Cmd>lua Scroll('z^', 0, 1)<CR>")
    vim.keymap.set("n", "z+", "<Cmd>lua Scroll('z+', 0, 1)<CR>")
    vim.keymap.set("n", "<C-y>", "<Cmd>lua Scroll('<C-y>', 0, 1)<CR>")
    vim.keymap.set("n", "<C-e>", "<Cmd>lua Scroll('<C-e>', 0, 1)<CR>")

    -- Horizontal screen scrolling:
    vim.keymap.set("n", "zH", "<Cmd>lua Scroll('zH')<CR>")
    vim.keymap.set("n", "zL", "<Cmd>lua Scroll('zL')<CR>")
    vim.keymap.set("n", "zs", "<Cmd>lua Scroll('zs')<CR>")
    vim.keymap.set("n", "ze", "<Cmd>lua Scroll('ze')<CR>")
    vim.keymap.set("n", "zh", "<Cmd>lua Scroll('zh', 0, 1)<CR>")
    vim.keymap.set("n", "zl", "<Cmd>lua Scroll('zl', 0, 1)<CR>")

    -- SCROLL_WHEEL_KEYMAPS:

    vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
    vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")

    ---search
    m.nname("<leader>s", "Search")

    nnoremap("<leader>sq", "<cmd>lua require('fzf-lua').quickfix({ multiprocess=true})<Cr>", "Search: quickfix")
    nnoremap("<leader>sr", "<cmd>lua require('plugins.fzflua').search_old_files()<Cr>", "Search: old files")
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
    nnoremap("gdd", "<cmd>lua Scroll('definition')<CR>", "GoTo: definition")
    nnoremap("gdv", "<cmd>:vsplit | lua Scroll('definition')<CR>", "GoTo: definition vertical")
    nnoremap("gds", "<cmd>:split | lua Scroll('definition')<CR>", "GoTo: definition horizontail")
    nnoremap("gDD", "<cmd>lua Scroll('declaration')<CR>", "GoTo: declaration")
    nnoremap("gDv", "<cmd>:vsplit | lua Scroll('declaration')<CR>", "GoTo: declaration vertical")
    nnoremap("gDs", "<cmd>:split | lua Scroll('declaration')<CR>", "GoTo: declaration horizontail")
    nnoremap(
        "gr",
        "<cmd>lua require('fzf-lua').lsp_references({ multiprocess=true,})<Cr>",
        "silent",
        "GoTo: references"
    )

    -- lang
    m.nname("<leader>l", "Language features")
    nnoremap("<leader>ld", "<cmd>Neogen<cr>", "silent", "Lang: generete docs")

    nnoremap("<leader>la", "<cmd>CodeActionMenu<cr>", "silent", "Lang: code action")

    vnoremap("<leader>lr", require("plugins.renamer").rename, "silent", "Lang: rename")
    nnoremap("<leader>lr", require("plugins.renamer").rename, "silent", "Lang: rename")

    local ssr_rename = function()
        require("ssr").open()
    end
    vnoremap("<leader>lR", ssr_rename, "silent", "Lang: rename ssr")
    nnoremap("<leader>lR", ssr_rename, "silent", "Lang: rename ssr")
    xnoremap("<leader>lR", ssr_rename, "silent", "Lang: rename ssr")

    nnoremap("<leader>lf", format, "silent", "Lang: lsp format")
    nnoremap("<leader>lp", "<cmd>lua require('zippy').insert_print()<CR>", "silent", "Lang: print variable")

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

    -- qf loclist
    nnoremap("<space>lo", "<cmd>lua require'qf'.open('l')<CR>", "Open location list")
    nnoremap("<space>lc", "<cmd>lua require'qf'.close('l')<CR>", " Close location list")
    nnoremap(
        "<space>ll",
        "<cmd>lua require'qf'.toggle('l', true)<CR>",
        "Toggle location list and stay in current window"
    )

    nnoremap("<space>co", "<cmd>lua require'qf'.open('c')<CR>", "Open quickfix list")
    nnoremap("<space>cc", "<cmd>lua require'qf'.close('c')<CR>", "Close quickfix list")
    nnoremap(
        "<space>cl",
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
    nnoremap({"<leader>w", "<leader>'"}, ":w<CR>", "silent", "normal mode: save")
    inoremap("<C-s>", "<Esc>:w<CR>l", "silent", "insert mode: escape to normal and save")
    vnoremap({"<leader>w", "<leader>'"}, "<Esc>:w<CR>", "visual mode: escape to normal and save")

    -- tests
    m.nname("t", "Tests")
    nnoremap("tt", '<cmd>lua require("neotest").run.run()<cr>', "Tests: run nearest test")
    nnoremap("ts", '<cmd>lua require("neotest").run.stop()<cr>', "Tests: stop nearest test")
    nnoremap("ta", '<cmd>lua require("neotest").run.attach()<cr>', "Tests: attach nearest test")
    nnoremap("tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Tests: run current file")

    m.nname("<leader>r", "PythonCopyReferences")
    nnoremap("<leader>rd", ":PythonCopyReferenceDotted<CR>")
    nnoremap("<leader>rp", ":PythonCopyReferencePytest<CR>")

    tnoremap("<C-Esc>", "<C-\\><C-n>:bd!")

    m.nname("<leader>t", "Tabs")
    nnoremap("<leader>ta", ":$tabnew<CR>", "Tabs: new")
    nnoremap("<leader>tc", ":tabclose<CR>", "Tabs: close")
    nnoremap("<leader>to", ":tabonly<CR>", "Tabs: close other tabs")
    nnoremap("<leader>tn", ":tabn<CR>", "Tabs: next")
    nnoremap("<leader>tp", ":tabp<CR>", "Tabs: prev")
    -- move current tab to previous position
    nnoremap("<leader>tmp", ":-tabmove<CR>", "Tabs: move to prev")
    -- move current tab to next position
    nnoremap("<leader>tmn", ":+tabmove<CR>", "Tabs: move to next")
end

return maps
