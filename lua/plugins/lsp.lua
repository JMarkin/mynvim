local is_not_mini = require("funcs").is_not_mini

return {
    "neovim/nvim-lspconfig",
    cond = is_not_mini,
    lazy = true,
    keys = {
        {
            "<space>bf",
            function()
                vim.lsp.buf.format({
                    async = true,
                })
            end,
        },
        {
            "gh",
            "<cmd>Lspsaga finder<CR>",
            desc = "Lsp: Finder",
        },
        { "ge", "<cmd>Lspsaga peek_definition<cr>", desc = "GoTo: definition float" },
        {
            "gdf",
            "<cmd>Lspsaga peek_definition<cr>",
            desc = "GoTo: definition float",
        },
        {
            "gdd",
            "<cmd>Lspsaga goto_definition<cr>",
            desc = "GoTo: definition",
        },
        {
            "gdv",
            "<cmd>:vsplit | Lspsaga goto_definition<CR>",
            desc = "GoTo: definition vertical",
        },
        {

            "gds",
            "<cmd>:split | Lspsaga goto_definition<CR>",
            desc = "GoTo: definition horizontail",
        },
        {

            "<leader>lk",
            "<cmd>Lspsaga hover_doc<CR>",
            silent = true,
            desc = "Lang: hover doc",
        },
        {

            "<leader>le",
            "<cmd>Lspsaga show_buf_diagnostics<CR>",
            silent = true,
            desc = "Lang: show buf disagnostic",
        },
        {

            "<leader>lE",
            "<cmd>Lspsaga show_workspace_diagnostics<CR>",
            silent = true,
            desc = "Lang: show workspace disagnostic",
        },
        {

            "<leader>la",
            "<cmd>Lspsaga code_action<cr>",
            silent = true,
            desc = "Lang: code action",
        },
        {
            "<leader>lr",
            "<cmd>Lspsaga rename<CR>",
            silent = true,
            desc = "Lang: rename",
        },
        {

            "<leader>lR",
            "<cmd>Lspsaga rename ++project<CR>",
            silent = true,
            desc = "Lang: rename project",
        },
        {
            "[e",
            "<cmd>Lspsaga diagnostic_jump_prev<CR>",
            desc = "Jump: prev diag",
        },
        {
            "]e",
            "<cmd>Lspsaga diagnostic_jump_next<CR>",
            desc = "Jump: next diag",
        },
        {
            "[E",
            function()
                require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end,
            desc = "Jump: prev Error",
        },
        {
            "]E",
            function()
                require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
            end,
            desc = "Jump: next Error",
        },
        {
            "<space>t",
            "<Cmd>Lspsaga outline<CR>",
            desc = "Tagbar",
        },
    },
    dependencies = {
        {
            "glepnir/lspsaga.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
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
                        enable = false,
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

                require("lspsaga").setup(opts)
            end,
        },
        {
            "j-hui/fidget.nvim",
            opts = {
                align = {
                    bottom = false, -- align fidgets along bottom edge of buffer
                    right = true, -- align fidgets along right edge of buffer
                },
            },
            tag = "legacy",
        },
        { "folke/neodev.nvim", opts = { lspconfig = false } },
    },
    config = function()
        require("lsp").setup()

        vim.diagnostic.config({
            underline = true,
            signs = true,
            virtual_text = false,
            -- virtual_lines = { only_current_line = true },
            float = true,
            update_in_insert = false,
            severity_sort = true,
        })
    end,
    event = { "BufReadPre", "FileReadPre" },
}
