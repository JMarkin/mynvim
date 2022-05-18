local M = {}

M.setup = function()
    vim.g.coq_settings = {
        auto_start = true,
        clients = {
            tmux = {
                enabled = true,
            },
        },
    }
end

M.config = function()
    require("settings.lang").config()

    require("fidget").setup({})
    require("lspsaga").setup({
        finder_action_keys = {
            open = "<cr>",
            vsplit = "v",
            split = "s",
            quit = "q",
        },
    })
    require("lsp_signature").setup({
        zindex = 49,
        auto_close_after = 1,
    })
    require("lsp-colors").setup({
        Error = "#E82424",
        Warning = "#FF9E3B",
        Information = "#6A9589",
        Hint = "#658594",
    })
    require("trouble").setup({
        padding = false,
        auto_open = false,
        auto_close = false,
        auto_preview = false,
        auto_fold = true,
        action_keys = { -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>", "s" }, -- open buffer in new split
            open_vsplit = { "<c-v>", "v" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = { "o" }, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = { "zM", "zm" }, -- close all folds
            open_folds = { "zR", "zr" }, -- open all folds
            toggle_fold = { "zA", "za" }, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j", -- next item
        },
        use_diagnostic_signs = true,
    })

    vim.diagnostic.config({
        underline = true,
        signs = true,
        virtual_text = true,
        float = true,
        update_in_insert = false,
        severity_sort = true,
    })
    -- require("lsp_lines").register_lsp_virtual_lines()
    -- vim.o.updatetime = 250
    -- vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]])
end

return M
