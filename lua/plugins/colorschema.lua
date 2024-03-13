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
            "scottmckendry/cyberdream.nvim",
            enabled = false,
            lazy = false,
            priority = math.huge,
            config = function()
                require("cyberdream").setup({
                    -- Recommended - see "Configuring" below for more config options
                    transparent = true,
                    italic_comments = true,
                    hide_fillchars = false,
                })
                vim.api.nvim_command("colorscheme cyberdream")
                vim.g.lualine_theme = "cyberdream"
            end,
        },
        {
            "polirritmico/monokai-nightasty.nvim",
            enabled = false,
            lazy = false,
            priority = math.huge,
            opts = {
                dark_style_background = "transparent", -- default, dark, transparent, #color
                light_style_background = "transparent", -- default, dark, transparent, #color
                color_headers = true, -- Enable header colors for each header level (h1, h2, etc.)
                lualine_bold = true, -- Lualine a and z sections font width
                lualine_style = "default", -- "dark", "light" or "default" (Follows dark/light style)
                -- Style to be applied to different syntax groups. See `:help nvim_set_hl`
                hl_styles = {
                    keywords = { italic = true },
                    comments = { italic = true },
                },
                sidebars = { "qf", "help" },
            },
            config = function(opts)
                require("monokai-nightasty").load(opts)
                -- vim.g.lualine_theme = "monokai-nightasty"
            end,
        },
        {
            "EdenEast/nightfox.nvim",
            enabled = true,
            lazy = false,
            priority = math.huge,
            config = function()
                -- Default options
                require("nightfox").setup({
                    options = {
                        -- Compiled file's destination location
                        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
                        compile_file_suffix = "_compiled", -- Compiled file suffix
                        transparent = false, -- Disable setting background
                        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                        dim_inactive = true, -- Non focused panes set to alternative background
                        module_default = true, -- Default enable value for modules
                        colorblind = {
                            enable = false, -- Enable colorblind support
                            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
                            severity = {
                                protan = 0, -- Severity [0,1] for protan (red)
                                deutan = 0, -- Severity [0,1] for deutan (green)
                                tritan = 0, -- Severity [0,1] for tritan (blue)
                            },
                        },
                        styles = { -- Style to be applied to different syntax groups
                            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
                            conditionals = "NONE",
                            constants = "NONE",
                            functions = "italic",
                            keywords = "bold",
                            numbers = "NONE",
                            operators = "NONE",
                            strings = "NONE",
                            types = "NONE",
                            variables = "NONE",
                        },
                        inverse = { -- Inverse highlight for different types
                            match_paren = false,
                            visual = false,
                            search = false,
                        },
                    },
                    palettes = {},
                    specs = {},
                    groups = {},
                })

                -- setup must be called before loading
                vim.cmd("colorscheme carbonfox")
                vim.g.lualine_theme = "carbonfox"
            end,
        },
    }
else
    vim.api.nvim_command("colorscheme default")
    return {}
end
