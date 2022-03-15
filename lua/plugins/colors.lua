return function()
    vim.opt.background = "dark"

    local onedarkpro = require("onedarkpro")
    onedarkpro.setup({
        theme = "onedark",
        hlgroups = {
            Comment = { fg = "#729ae0", style = "italic" },
        },
        plugins = { -- Override which plugins highlight groups are loaded
            all = false,
            gitsigns_nvim = true,
            native_lsp = true,
            treesitter = true,
            lsp_saga = true,
            nvim_tree = true,
            nvim_ts_rainbow = false,
            trouble_nvim = true,
            which_key_nvim = true,
            indentline = true,
        },
        styles = {
            strings = "NONE", -- Style that is applied to strings
            comments = "italic", -- Style that is applied to comments
            keywords = "bold,underline", -- Style that is applied to keywords
            functions = "bold,undercurl", -- Style that is applied to functions
            variables = "NONE", -- Style that is applied to variables
        },
        options = {
            bold = true, -- Use the themes opinionated bold styles?
            italic = true, -- Use the themes opinionated italic styles?
            underline = true, -- Use the themes opinionated underline styles?
            undercurl = true, -- Use the themes opinionated undercurl styles?
            cursorline = true, -- Use cursorline highlighting?
            transparency = false, -- Use a transparent background?
            terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
            window_unfocussed_color = true, -- When the window is out of focus, change the normal background?
        },
    })
    onedarkpro.load()

    local present, lualine = pcall(require, "lualine")
    if present then
        lualine.setup({
            extensions = { "quickfix", "nvim-tree", "fzf" },
            options = { disabled_filetypes = { "Trouble", "Vista" } },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                    { "diagnostics", sources = { "nvim_diagnostic" } },
                },
                lualine_c = {
                    "filesize",
                    { "filename", path = 1 },
                },
                lualine_x = {
                    "encoding",
                    {
                        "fileformat",
                        icons_enabled = true,
                        symbols = {
                            unix = "LF",
                            dos = "CRLF",
                            mac = "CR",
                        },
                    },
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end
end
