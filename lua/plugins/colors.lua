return function()
    local lualine = require("lualine")

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

    local colorscheme = "highlite"
    local background = "dark"

    if colorscheme == "deus" then
        vim.g.deus_background = "hard"
    end

    if colorscheme == "kanagawa" then
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
            globalStatus = true, -- adjust window separators highlight for laststatus=3
            colors = {},
            overrides = {},
        })
    end

    if colorscheme == "catppuccin" then
        vim.g.catppuccin_flavour = "frappe"
        require("catppuccin").setup({
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.15,
            },
            transparent_background = true,
            term_colors = true,
            compile = {
                enabled = true,
                path = vim.fn.stdpath("cache") .. "/catppuccin",
            },
            styles = {
                comments = { "italic" },
                conditionals = { "bold" },
                loops = { "bold" },
                functions = { "bold" },
                keywords = { "bold" },
                strings = { "italic" },
                variables = {},
                numbers = { "italic" },
                booleans = { "italic" },
                properties = { "undercurl" },
                types = { "italic" },
                operators = {},
            },
            integrations = {
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                coc_nvim = false,
                lsp_trouble = true,
                cmp = true,
                lsp_saga = true,
                gitgutter = false,
                gitsigns = true,
                leap = true,
                telescope = false,
                nvimtree = false,
                neotree = {
                    enabled = true,
                    show_root = true,
                    transparent_panel = true,
                },
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                which_key = true,
                indent_blankline = {
                    enabled = false,
                    colored_indent_levels = false,
                },
                dashboard = true,
                markdown = true,
                ts_rainbow = true,
                notify = true,
                telekasten = false,
                symbols_outline = true,
                vimwiki = true,
            },
            color_overrides = {},
            highlight_overrides = {},
        })
    else
        vim.opt.background = background
    end
    local vim_colorscheme = "colorscheme " .. colorscheme
    vim.cmd(vim_colorscheme)

    lualine.setup({
        extensions = { "quickfix", "nvim-tree", "fzf", "symbols-outline", "nvim-dap-ui", "toggleterm" },
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
                "lsp_progress",
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
