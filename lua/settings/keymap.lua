local cmd = vim.cmd

local format = function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls" or client.name == "rust_analyzer"
        end,
        async = true,
    })
end

function maps(m)
    nnoremap({ "<leader>q", "<space>q" }, ":q<cr>", "Quit")

    --------Основное управление буферами
    m.nname("<space>b", "Buffer")

    nnoremap("<space>bd", "<cmd>Bdelete this<Cr>", "Buffer: delete current")
    nnoremap("<space>bc", "<cmd>Bdelete other<Cr>", "Buffer: delete other")

    nnoremap("<space>bf", format, "silent", "Lang: lsp format")

    nnoremap({ "<space><right>" }, function()
        require("smart-splits").move_cursor_right()
    end, "silent", "right")
    nnoremap({ "<space><down>" }, function()
        require("smart-splits").move_cursor_down()
    end, "silent", "down")
    nnoremap({ "<space><up>" }, function()
        require("smart-splits").move_cursor_up()
    end, "silent", "top")
    nnoremap({ "<space><left>" }, function()
        require("smart-splits").move_cursor_left()
    end, "silent", "left")

    -- resizing splits
    nnoremap({ "<A-left>" }, function()
        require("smart-splits").resize_left()
    end, "silent", "Resize left")
    nnoremap({ "<A-down>" }, function()
        require("smart-splits").resize_down()
    end, "silent", "Resize down")
    nnoremap({ "<A-up>" }, function()
        require("smart-splits").resize_up()
    end, "silent", "Resize up")
    nnoremap({ "<A-right>" }, function()
        require("smart-splits").resize_right()
    end, "silent", "Resize right")

    ---------Тогл Инструментов
    nnoremap("<space>f", "<Cmd>NvimTreeOpen<CR>", "FileTree")
    nnoremap("<space>t", "<Cmd>Lspsaga outline<CR>", "Tagbar")
    nnoremap("<space>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>", "Git: blame")
    nnoremap("<space>E", "<cmd>TroubleToggle workspace_diagnostics<cr>", "All Diagnostics")
    nnoremap("<space>e", "<cmd>TroubleToggle document_diagnostics<cr>", "Buffer Diagnostics")
    nnoremap("<space>T", "<Cmd>Lspsaga term_toggle<CR>", "Terminal")
    nnoremap("<space>G", "<Cmd>LazyGit<CR>", "Git: lazygit")

    nnoremap("<space>r", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Resize mode")

    ---- Fold
    m.nname("z", "Fold")

    ---- Перемещения

    -- Half-window movements:
    vim.keymap.set({ "n", "x" }, "<C-u>", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<C-d>", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "K", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "J", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")

    -- Page movements:
    vim.keymap.set({ "n", "x" }, "<C-b>", "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<C-f>", "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<PageUp>", "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>")
    vim.keymap.set({ "n", "x" }, "<PageDown>", "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>")

    -- EXTRA_KEYMAPS:

    -- Start/end of file and line number movements:
    -- vim.keymap.set({ "n", "x" }, "gg", "<Cmd>lua Scroll('gg')<CR>")
    -- vim.keymap.set({ "n", "x" }, "G", "<Cmd>lua Scroll('G', 0, 1)<CR>")

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
    nnoremap("gt", "<cmd>Lspsaga peek_definition<cr>", "GoTo: definition float")
    nnoremap("gdd", "<cmd>Lspsaga goto_definition<cr>", "GoTo: definition")
    nnoremap("gdv", "<cmd>:vsplit | Lspsaga goto_definition<CR>", "GoTo: definition vertical")
    nnoremap("gds", "<cmd>:split | Lspsaga goto_definition<CR>", "GoTo: definition horizontail")
    nnoremap(
        "gr",
        "<cmd>lua require('fzf-lua').lsp_references({ multiprocess=true,})<Cr>",
        "silent",
        "GoTo: references"
    )
    nnoremap("gh", "<cmd>Lspsaga lsp_finder<CR>", "Lsp: Finder")

    -- lang
    m.nname("<leader>l", "Language features")
    nnoremap("<leader>lk", "<cmd>Lspsaga hover_doc<CR>", "silent", "lang: hover doc")
    nnoremap("<leader>ld", "<cmd>Neogen<cr>", "silent", "Lang: generete docs")

    nnoremap("<leader>la", "<cmd>Lspsaga code_action<cr>", "silent", "Lang: code action")

    nnoremap("<leader>lr", "<cmd>Lspsaga rename<CR>", "silent", "Lang: rename")
    nnoremap("<leader>lR", "<cmd>Lspsaga rename ++project<CR>", "silent", "Lang: rename project")

    nnoremap("<leader>lf", format, "silent", "Lang: lsp format")
    nnoremap("<Leader>li", "<cmd>Lspsaga incoming_calls<CR>")
    nnoremap("<Leader>lo", "<cmd>Lspsaga outgoing_calls<CR>")

    m.nname("<leader>lc", "Copy")
    nnoremap("<leader>lcd", ":PythonCopyReferenceDotted<CR>")
    nnoremap("<leader>lcp", ":PythonCopyReferencePytest<CR>")

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
    nnoremap("<leader>ba", "<cmd>lua require('plugins.bookmark').search()<Cr>", "Bookmark: ShowAll")
    nnoremap("<leader>bj", "<Plug>BookmarkNext", "Bookmark: Next")
    nnoremap("<leader>bk", "<Plug>BookmarkPrev", "Bookmark: Prev")
    nnoremap("<leader>bc", "<Plug>BookmarkClear", "Bookmark: Clear")
    nnoremap("<leader>bx", "<Plug>BookmarkClearAll", "Bookmark: ClearAll")
    nnoremap("<leader>bkk", "<Plug>BookmarkMoveUp", "Bookmark: MoveUp")
    nnoremap("<leader>bjj", "<Plug>BookmarkMoveDown", "Bookmark: MoveDown")
    nnoremap("<leader>bg", "<Plug>BookmarkMoveToLine", "Bookmark: MoveToLine")

    -- todo
    vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })

    -- windows
    nnoremap("<space>w", function()
        require("nvim-window").pick()
    end, "silent", "Windows: pick")

    --save shortcut
    nnoremap({ "<leader>w", "<leader>'" }, ":w<CR>", "silent", "normal mode: save")
    inoremap("<C-s>", "<Esc>:w<CR>l", "silent", "insert mode: escape to normal and save")
    vnoremap({ "<leader>w", "<leader>'" }, "<Esc>:w<CR>", "visual mode: escape to normal and save")

    -- tests
    m.nname("t", "Tests")
    nnoremap("tt", '<cmd>lua require("neotest").run.run()<cr>', "Tests: run nearest test")
    nnoremap("ts", '<cmd>lua require("neotest").run.stop()<cr>', "Tests: stop nearest test")
    nnoremap("ta", '<cmd>lua require("neotest").run.attach()<cr>', "Tests: attach nearest test")
    nnoremap("tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Tests: run current file")

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

    nnoremap("[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    nnoremap("]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

    -- Diagnostic jump with filters such as only jumping to an error
    nnoremap("[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    nnoremap("]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)
end

return maps
