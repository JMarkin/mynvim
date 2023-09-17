return {

    {
        "ofirgall/ofirkai.nvim",
        lazy = true,
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
}
