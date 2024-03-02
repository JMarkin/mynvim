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
        -- {
        --     "Iron-E/nvim-highlite",
        --     enabled = true,
        --     lazy = false,
        --     priority = math.huge,
        --     config = function(_, opts)
        --         -- OPTIONAL: setup the plugin. See "Configuration" for information
        --         require("highlite").setup({
        --             generator = {
        --                 plugins = {
        --                     terminal_palette = true,
        --                     syntax = true,
        --                     nvim = {
        --
        --                         aerial = false,
        --                         barbar = false,
        --                         bqf = true,
        --                         cmp = true,
        --                         fzf = true,
        --                         gitsigns = true,
        --                         indent_blankline = true,
        --                         lazy = true,
        --                         leap = false,
        --                         lspconfig = true,
        --                         lspsaga = true,
        --                         lsp_signature = false,
        --                         mini = true,
        --                         neo_tree = false,
        --                         neotest = true,
        --                         nvim_tree = true,
        --                         packer = false,
        --                         registers = false,
        --                         symbols_outline = false,
        --                         telescope = false,
        --                         todo_comments = true,
        --                         treesitter_context = false,
        --                         trouble = false,
        --                     },
        --                     vim = {
        --                         ale = false,
        --                         coc = false,
        --                         dadbod_ui = true,
        --                         easymotion = false,
        --                         fern = false,
        --                         gitgutter = false,
        --                         indent_guides = false,
        --                         jumpmotion = false,
        --                         nerdtree = false,
        --                         sandwich = false,
        --                         signify = false,
        --                         swap = false,
        --                         undotree = false,
        --                         win = false,
        --                     },
        --                 },
        --             },
        --         })
        --
        --         -- or one of the alternate colorschemes (see the "Built-in Colorschemes" section)
        --         vim.api.nvim_command("colorscheme highlite")
        --         vim.cmd([[ highlight Normal ctermbg=NONE guibg=NONE ]])
        --     end,
        --     version = "^4.0.0",
        --     build = function()
        --         require("highlite.export").bat("highlite", { force = true })
        --     end,
        -- },
        {
            "sekke276/dark_flat.nvim",
            enabled = true,
            lazy = false,
            priority = math.huge,
            config = function()
                require("dark_flat").setup({
                    transparent = true,
                    italics = true,
                })
                vim.api.nvim_command("colorscheme dark_flat")
                vim.g.lualine_theme = "dark_flat"
            end,
            -- dependencies = "Iron-E/nvim-highlite",
            -- build = function()
            --     require("highlite.export").bat("dark_flat", { force = true })
            --     require("highlite.export").wezterm("dark_flat", { force = true, dir = "~/.config/wezterm" })
            -- end,
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
            -- dependencies = "Iron-E/nvim-highlite",
            -- build = function()
            --     require("highlite.export").bat("cyberdream", { force = true })
            --     require("highlite.export").wezterm("cyberdream", { force = true, dir = "~/.config/wezterm" })
            -- end,
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
    }
else
    vim.api.nvim_command("colorscheme default")
    return {}
end
