vim.g.rainbow_delimiters_highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LocalHighlight", { link = "Debug" })
        vim.api.nvim_set_hl(0, "DiffAdd", { link = "Added" })
        vim.api.nvim_set_hl(0, "DiffDelete", { link = "Removed" })
        vim.api.nvim_set_hl(0, "DiffChange", { link = "Changed" })

        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#202020" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b0b0b0", bg = "#202020" })

        vim.api.nvim_set_hl(0, "ColorColumn", { fg = "#b0b0b0", bg = "#202020" })

        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end,
})

if vim.g.modern_ui then
    return {
        {
            "sekke276/dark_flat.nvim",
            enabled = false,
            lazy = false,
            priority = math.huge,
            config = function()
                require("dark_flat").setup({
                    -- transparent = true,
                    italics = true,
                })
                vim.api.nvim_command("colorscheme dark_flat")
                vim.g.lualine_theme = "dark_flat"
            end,
        },
        {
            "ribru17/bamboo.nvim",
            enabled = true,
            lazy = false,
            priority = math.huge,
            config = function()
                require("bamboo").setup({
                    code_style = {
                        comments = { italic = true },
                        conditionals = { italic = true },
                        keywords = { bold = true },
                        functions = { bold = true },
                        namespaces = { italic = true },
                        parameters = { italic = true },
                        strings = {},
                        variables = {},
                    },
                    dim_inactive = true,
                    -- style = "multiplex",
                    transparent = false,
                    lualine = {
                        transparent = true, -- lualine center bar transparency
                    },
                    diagnostics = {
                        darker = true, -- darker colors for diagnostic
                        undercurl = true, -- use undercurl instead of underline for diagnostics
                        background = true, -- use background color for virtual text
                    },
                })
                require("bamboo").load()
            end,
        },
    }
else
    vim.api.nvim_command("colorscheme default")
    return {}
end
