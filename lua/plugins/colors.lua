return function()
    local lualine = require("lualine")

    local colorscheme = "highlite"
    local background = "dark"

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
