local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
vim.g.rainbow_delimiters_highlight = highlight

return {
    {
        "Iron-E/nvim-highlite",
        config = function()
            local Highlite = require("highlite")

            local palette, _ = Highlite.palette("highlite")

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
                            indent_blankline = true,
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
                    vim.api.nvim_set_hl(0, "Error", { undercurl = true })
                    vim.api.nvim_set_hl(0, "Normal", { guibg = nil })
                end,
                group = vim.api.nvim_create_augroup("config", { clear = true }),
                -- pattern = "highlite",
            })

            local design = {
                border = "single",
                winhighlight = "Normal:CmpFloat,FloatBorder:CmpFloatBorder,CursorLine:Visual,Search:None",
                zindex = 1001,
            }

            vim.g.cmp_window = {
                completion = design,
                documentation = design,
            }
            vim.g.lualine_theme = "powerline_dark"

            vim.api.nvim_command("colorscheme highlite-papercolor")
        end,
        lazy = false,
        priority = math.huge,
        enabled = false,
    },
    {
        "ofirgall/ofirkai.nvim",
        enabled = false,
        lazy = false,
        priority = math.huge,
        config = function()
            require("ofirkai").setup({})

            vim.api.nvim_set_hl(0, "LspInlayHint", { link = "InlayHints", default = true })

            for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
                vim.api.nvim_set_hl(0, group, {})
            end

            -- local links = {
            --     ["@lsp.type.namespace"] = "@namespace",
            --     ["@lsp.type.type"] = "@type",
            --     ["@lsp.type.class"] = "@type",
            --     ["@lsp.type.enum"] = "@type",
            --     ["@lsp.type.interface"] = "@type",
            --     ["@lsp.type.struct"] = "@structure",
            --     ["@lsp.type.parameter"] = "@parameter",
            --     ["@lsp.type.variable"] = "@variable",
            --     ["@lsp.type.property"] = "@property",
            --     ["@lsp.type.enumMember"] = "@constant",
            --     ["@lsp.type.function"] = "@function",
            --     ["@lsp.type.method"] = "@method",
            --     ["@lsp.type.macro"] = "@macro",
            --     ["@lsp.type.decorator"] = "@function",
            -- }
            -- for newgroup, oldgroup in pairs(links) do
            --     vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
            -- end

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
    {
        "polirritmico/monokai-nightasty.nvim",
        lazy = false,
        priority = math.huge,
        config = function()
            require("monokai-nightasty").setup({
                dark_style_background = "transparent", -- default, dark, transparent, #color
                light_style_background = "default", -- default, dark, transparent, #color
                terminal_colors = true, -- Set the colors used when opening a `:terminal`
                color_headers = true, -- Enable header colors for each header level (h1, h2, etc.)
                hl_styles = {
                    -- Style to be applied to different syntax groups. See `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = false, bold = true },
                    functions = { bold = true },
                    variables = {},
                    -- Background styles for sidebars (panels) and floating windows:
                    floats = "default", -- default, dark, transparent
                    sidebars = "transparent", -- default, dark, transparent
                },
                sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`

                hide_inactive_statusline = false, -- Hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
                dim_inactive = true, -- dims inactive windows
                lualine_bold = true, -- Lualine headers will be bold or regular.
                lualine_style = "default", -- "dark", "light" or "default" (Follows dark/light style)

                --- You can override specific color/highlights. Current values in `extras/palettes`

                ---@param colors ColorScheme
                -- on_colors = function(colors)
                --     colors.border = colors.grey
                --     colors.comment = "#2d7e79"
                -- end,

                ---@param highlights Highlights
                ---@param colors ColorScheme
                -- on_highlights = function(highlights, colors)
                --     highlights.TelescopeNormal = { fg = colors.magenta, bg = colors.charcoal }
                --     highlights.WinSeparator = { fg = colors.grey }
                -- end,
            })
            vim.api.nvim_command("colorscheme monokai-nightasty")
            vim.g.lualine_theme = "monokai-nightasty"
        end,
    },
}
