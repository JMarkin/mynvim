local function get_status_line()
    if not pcall(require, "lsp_signature") then
        return nil
    end
    return require("lsp_signature").status_line(1000)
end

local current_signature_label = function()
    local sig = get_status_line()

    if not sig then
        return ""
    end
    if sig.label == "" then
        return ""
    end

    return sig.label:sub(0, sig.range.start - 1)
end

local current_signature_hint = function()
    local sig = get_status_line()
    if not sig then
        return ""
    end
    return sig.hint
end

local current_signature_label_end = function()
    local sig = get_status_line()

    if not sig then
        return ""
    end
    if sig.label == "" then
        return ""
    end

    return sig.label:sub(sig.range["end"] + 1)
end

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
            globalStatus = true, -- adjust window separators highlight for laststatus=3
            colors = {},
            overrides = {},
        })
    end

    if colorscheme == "highlite" then
        vim.cmd("colorscheme kanagawa")
    end

    vim.opt.background = background

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
                { current_signature_label, icons_enabled = false },
                { current_signature_hint, icons_enabled = false, color = "LspSignatureActiveParameter" },
                { current_signature_label_end, icons_enabled = false },
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
