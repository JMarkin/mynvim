local M = {}

M.setup = function()
    vim.g.coq_settings = {
        auto_start = "shut-up",
        clients = {
            tmux = {
                enabled = true,
            },
        },
    }
end

M.config = function()
    require("settings.lang").config()

    require("lspsaga").init_lsp_saga({
        finder_action_keys = {
            open = "<cr>",
        },
        code_action_lightbulb = {
            enable = false,
        },
        symbol_in_winbar = {
            in_custom = false,
            enable = vim.fn.has("nvim-0.8") == 1,
            separator = " ",
            show_file = true,
        },
    })
    require("trouble").setup({
        padding = false,
        auto_open = false,
        auto_close = true,
        auto_preview = true,
        auto_fold = true,
        mode = "document_diagnostics",
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
        virtual_text = false,
        float = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_lines = false,
    })
end

return M
