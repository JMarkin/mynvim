return {
    {
        "Iron-E/nvim-highlite",
        config = function(_, opts)
            local Highlite = require("highlite")

            local palette, terminal_palette = Highlite.palette("highlite")

            require("highlite").setup({
                generator = {
                    plugins = {
                        nvim = {
                            aerial = false,
                            barbar = false,
                            bqf = true,
                            cmp = true,
                            fzf = true,
                            gitsigns = true,
                            indent_blankline = false,
                            lazy = true,
                            leap = false,
                            lspconfig = true,
                            lspsaga = true,
                            lsp_signature = false,
                            mini = true,
                            neo_tree = false,
                            nvim_tree = true,
                            packer = false,
                            registers = false,
                            symbols_outline = false,
                            telescope = false,
                            todo_comments = true,
                            trouble = false,
                        },
                    },
                    vim = {

                        ale = false,
                        coc = false,
                        dadbod_ui = true,
                        easymotion = false,
                        fern = false,
                        gitgutter = false,
                        indent_guides = false,
                        jumpmotion = false,
                        nerdtree = false,
                        sandwich = false,
                        signify = false,
                        swap = false,
                        undotree = false,
                        win = false,
                    },
                    syntax = true,
                },
            })

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = palette.error, bold = true })
                    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = palette.hint, bold = true })
                    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = palette.info, bold = true })
                    vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = palette.ok, bold = true })
                    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = palette.warning, bold = true })
                    vim.api.nvim_set_hl(0, "DiffAdd", { fg = palette.string })
                    vim.api.nvim_set_hl(0, "DiffDelete", { fg = palette.error })
                    vim.api.nvim_set_hl(0, "DiffText", { fg = palette.diff_change })
                end,
                group = vim.api.nvim_create_augroup("config", { clear = true }),
                -- pattern = "highlite",
            })

            vim.api.nvim_command("colorscheme highlite-papercolor")
        end,
        lazy = false,
        priority = math.huge,
        enabled = true,
    },
    {
        "ofirgall/ofirkai.nvim",
        enabled = false,
        lazy = false,
        priority = math.huge,
        config = function()
            require("ofirkai").setup({})

            vim.api.nvim_set_hl(0, "LspInlayHint", { link = "InlayHints", default = true })

            -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
            --     vim.api.nvim_set_hl(0, group, {})
            -- end

            local links = {
                ["@lsp.type.namespace"] = "@namespace",
                ["@lsp.type.type"] = "@type",
                ["@lsp.type.class"] = "@type",
                ["@lsp.type.enum"] = "@type",
                ["@lsp.type.interface"] = "@type",
                ["@lsp.type.struct"] = "@structure",
                ["@lsp.type.parameter"] = "@parameter",
                ["@lsp.type.variable"] = "@variable",
                ["@lsp.type.property"] = "@property",
                ["@lsp.type.enumMember"] = "@constant",
                ["@lsp.type.function"] = "@function",
                ["@lsp.type.method"] = "@method",
                ["@lsp.type.macro"] = "@macro",
                ["@lsp.type.decorator"] = "@function",
            }
            for newgroup, oldgroup in pairs(links) do
                vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
            end

            vim.g.cmp_window = require("ofirkai.plugins.nvim-cmp").window
            local scheme = require("ofirkai.design").scheme
            vim.g.lspsaga_colors = {
                normal_bg = scheme.ui_bg,
                title_bg = scheme.mid_orange,
            }
            vim.g.notify_background_color = require("ofirkai").scheme.ui_bg
            vim.g.lualine_theme = require("ofirkai.statuslines.lualine").theme
            vim.g.dressing_winhighlight = require("ofirkai.plugins.dressing").winhighlight
        end,
    },
}
