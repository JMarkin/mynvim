local lualine = require("lualine")

lualine.setup({
    extensions = { "quickfix", "nvim-tree", "fzf", "symbols-outline", "nvim-dap-ui", "toggleterm" },
    options = {
        disabled_filetypes = { "Trouble", "Vista", "dashboard" },
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
