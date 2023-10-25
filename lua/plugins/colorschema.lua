vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LocalHighlight", { link = "Debug" })
    end,
})

return {
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
        enabled = true,
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
