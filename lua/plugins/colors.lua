return function()
    local style = {
        string = "NONE",
        comments = "italic",
        keywords = "bold,undercurl",
        functions = "bold,undercurl",
        tags = "bold,italic",
        variables = "NONE",
        statemant = "bold",
        type = "bold,italic",
    }

    local colorscheme = "sonokai"
    local background = "dark"

    if colorscheme == "sonokai" then
        vim.g.sonokai_style = "andromeda"
        vim.g.sonokai_better_perfomance = 1
        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_transparent_background = 1
        vim.g.sonokai_spell_foreground = 1
        vim.g.sonokai_show_eob = 1
        vim.g.sonokai_diagnostic_text_highlight = 1
        vim.g.sonokai_diagnostic_line_highlight = 1
        vim.g.sonokai_diagnostic_virtual_text = 1
    end

    if colorscheme == "onedarkpro" then
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
                nvim_ts_rainbow = true,
                trouble_nvim = true,
                which_key_nvim = true,
                indentline = true,
            },
            styles = style,
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
    end

    if colorscheme == "gruvbox-baby" then
        vim.g.gruvbox_baby_function_style = style.functions
        vim.g.gruvbox_baby_comment_style = style.comments
        vim.g.gruvbox_baby_keyword_style = style.keywords
        vim.g.gruvbox_baby_variable_style = style.variables
    end

    if colorscheme == "kanagawa" or colorscheme == "highlite" then
        require("kanagawa").setup({
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = { bold = true, undercurl = true },
            keywordStyle = { bold = true, undercurl = true },
            statementStyle = { bold = true },
            typeStyle = { bold = true, italic = true },
            specialReturn = true, -- special highlight for the return keyword
            specialException = true, -- special highlight for exception handling keywords
            transparent = false, -- do not set background color
            dimInactive = true, -- dim inactive window `:h hl-NormalNC`
            globalStatus = false, -- adjust window separators highlight for laststatus=3
            colors = {},
            overrides = {},
        })
    end

    if colorscheme == "highlite" then
        vim.cmd("colorscheme kanagawa")
    end

    if colorscheme == "aurora" then
        vim.cmd([[
            let g:aurora_italic=1
            let g:aurora_bold=1
        ]])
    end

    if colorscheme == "catppuccin" then
        require("catppuccin").setup({
            styles = {
                comments = style.comments,
                conditionals = style.statemant,
                loops = "NONE",
                functions = style.functions,
                keywords = style.keywords,
                strings = style.string,
                variables = style.variables,
                numbers = "NONE",
                booleans = "NONE",
                properties = "NONE",
                types = style.type,
                operators = style.statemant,
            },
            integrations = {
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = "italic",
                        hints = "italic",
                        warnings = "italic",
                        information = "italic",
                    },
                    underlines = {
                        errors = "underline",
                        hints = "underline",
                        warnings = "underline",
                        information = "underline",
                    },
                },
                coc_nvim = false,
                lsp_trouble = false,
                cmp = false,
                lsp_saga = true,
                gitgutter = false,
                gitsigns = false,
                telescope = false,
                nvimtree = {
                    enabled = true,
                    show_root = true,
                    transparent_panel = true,
                },
                neotree = {
                    enabled = false,
                    show_root = false,
                    transparent_panel = false,
                },
                which_key = true,
                indent_blankline = {
                    enabled = false,
                    colored_indent_levels = false,
                },
                dashboard = false,
                neogit = false,
                vim_sneak = false,
                fern = false,
                barbar = false,
                bufferline = false,
                markdown = true,
                lightspeed = true,
                ts_rainbow = true,
                hop = false,
                notify = true,
                telekasten = false,
                symbols_outline = true,
            },
        })
        vim.g.catppuccin_flavour = "macchiato"
    end

    vim.opt.background = background

    if colorscheme == "newpaper" then
        require("newpaper").setup({
            style = background,
            sidebars_contrast = { "Trouble", "NvimTree", "qf", "Outline", "terminal", "packer" },
            keywords = style.keywords,
            tags = style.tags,
            error_highlight = "both",
        })
    end

    local vim_colorscheme = "colorscheme " .. colorscheme
    vim.cmd(vim_colorscheme)

    local present, lualine = pcall(require, "lualine")
    if present then
        lualine.setup({
            extensions = { "quickfix", "nvim-tree", "fzf" },
            options = {
                disabled_filetypes = { "Trouble", "Vista" },
                theme = "auto",
            },
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
