local ok, lspsaga = pcall(require, "lspsaga")

if not ok then
    return
end

local ok_ofirkai, ofirkai_design = pcall(require, "ofirkai.design")

local opts = {
    finder = {
        jump_to = "p",
        edit = { "o", "<CR>" },
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "t",
        quit = { "q", "<ESC>" },
    },
    definition = {
        edit = "<C-c>o",
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "<C-c>t",
        quit = "q",
        close = "<Esc>",
    },
    rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
    },
    callhierarchy = {
        show_detail = true,
        keys = {
            edit = "e",
            vsplit = "<C-v>",
            split = "<C-s>",
            tabe = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u",
        },
    },
    symbol_in_winbar = {
        enable = true,
        separator = " ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = true,
        color_mode = true,
    },
    lightbulb = {
        enable = false,
    },
    diagnostic = {
        on_insert = false,
        on_insert_follow = false,
        insert_winblend = 0,
        show_virt_line = true,
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        --1 is max
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = true,
        border_follow = true,
        keys = {
            exec_action = "o",
            quit = "q",
            go_action = "g",
            expand_or_jump = "<CR>",
        },
    },
}

if ok_ofirkai then
    local scheme = ofirkai_design.scheme
    opts.ui = {
        colors = {
            normal_bg = scheme.ui_bg,
            title_bg = scheme.mid_orange,
        },
    }
end

lspsaga.setup(opts)

vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = "Lsp: Finder" })
vim.keymap.set("n", "ge", "<cmd>Lspsaga peek_definition<cr>", { desc = "GoTo: definition float" })
vim.keymap.set("n", "gdd", "<cmd>Lspsaga goto_definition<cr>", { desc = "GoTo: definition" })
vim.keymap.set("n", "gdv", "<cmd>:vsplit | Lspsaga goto_definition<CR>", { desc = "GoTo: definition vertical" })
vim.keymap.set("n", "gds", "<cmd>:split | Lspsaga goto_definition<CR>", { desc = "GoTo: definition horizontail" })

vim.keymap.set("n", "<leader>lk", "<cmd>Lspsaga hover_doc<CR>", { silent = true, desc = "Lang: hover doc" })
vim.keymap.set(
    "n",
    "<leader>le",
    "<cmd>Lspsaga show_buf_diagnostics<CR>",
    { silent = true, desc = "Lang: show buf disagnostic" }
)

vim.keymap.set(
    "n",
    "<leader>lE",
    "<cmd>Lspsaga show_workspace_diagnostics<CR>",
    { silent = true, desc = "Lang: show workspace disagnostic" }
)

vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", { silent = true, desc = "Lang: code action" })

vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "Lang: rename" })
vim.keymap.set("n", "<leader>lR", "<cmd>Lspsaga rename ++project<CR>", { silent = true, desc = "Lang: rename project" })

vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Jump: prev diag" })
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Jump: next diag" })

-- Diagnostic jump with filters such as only jumping to an error
vim.keymap.set("n", "[E", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Jump: prev Error" })
vim.keymap.set("n", "]E", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Jump: next Error" })

vim.keymap.set("n", "<space>t", "<Cmd>Lspsaga outline<CR>", { desc = "Tagbar" })
