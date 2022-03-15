local highlight = function(group, fg, bg, attr, sp)
    fg = fg and "guifg=" .. fg or "guifg=NONE"
    bg = bg and "guibg=" .. bg or "guibg=NONE"
    attr = attr and "gui=" .. attr or "gui=NONE"
    sp = sp and "guisp=" .. sp or ""

    vim.api.nvim_command("highlight " .. group .. " " .. fg .. " " .. bg .. " " .. attr .. " " .. sp)
end

return function()
    vim.opt.background = "dark"

    --- gruvbox
    -- vim.g.gruvbox_material_background = "soft"
    -- vim.g.gruvbox_material_palette = "mix"
    -- vim.g.gruvbox_material_enable_italic = true
    -- vim.g.gruvbox_material_enable_bold = true
    -- vim.g.gruvbox_material_diagnostic_text_highlight = true
    -- vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    -- vim.g.gruvbox_material_diagnostic_line_highlight = true
    -- --- sonokai
    -- vim.g.sonokai_style = "andromeda"
    -- vim.g.sonokai_enable_italic = true
    -- vim.g.sonokai_enable_bold = true
    -- vim.g.sonokai_diagnostic_text_highlight = true
    -- vim.g.sonokai_diagnostic_virtual_text = "colored"
    -- vim.g.sonokai_diagnostic_line_highlight = true

    -- require("kanagawa").setup({
    -- 	undercurl = true, -- enable undercurls
    -- 	commentStyle = "italic",
    -- 	functionStyle = "NONE",
    -- 	keywordStyle = "italic",
    -- 	statementStyle = "bold",
    -- 	typeStyle = "NONE",
    -- 	variablebuiltinStyle = "italic",
    -- 	specialReturn = true, -- special highlight for the return keyword
    -- 	specialException = true, -- special highlight for exception handling keywords
    -- 	transparent = false, -- do not set background color
    -- 	colors = {},
    -- 	overrides = {},
    -- })
    --vim.cmd("colorscheme kanagawa")

    local onedarkpro = require("onedarkpro")
    onedarkpro.setup({
        theme = "onedark",
        hlgroups = {},
        plugins = { -- Override which plugins highlight groups are loaded
            all = false,
            gitsigns_nvim = true,
            native_lsp = true,
            treesitter = true,
            lsp_saga = true,
            nvim_tree = true,
            nvim_ts_rainbow = true,
            trouble_nvim = true,
            which_key_nvim = true,
            indentline = true,
        },
        styles = {
            strings = "NONE", -- Style that is applied to strings
            comments = "italic", -- Style that is applied to comments
            keywords = "bold,underline", -- Style that is applied to keywords
            functions = "bold", -- Style that is applied to functions
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

    -- require("themer").setup({
    -- 	colorscheme = "onedark",
    -- 	styles = {
    -- 		string = { style = "NONE" },
    -- 		comment = { style = "italic" },
    -- 		keyword = { style = "bold,underline" },
    -- 		keywordBuiltIn = { style = "bold,underline" },
    -- 		["function"] = { style = "bold" },
    -- 		variable = { style = "NONE" },
    -- 		variableBuiltIn = { style = "NONE" },
    -- 	},
    -- })

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
