return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            extensions = { "quickfix", "nvim-tree", "fzf", "symbols-outline", "nvim-dap-ui", "toggleterm" },
            options = {
                disabled_filetypes = { "Trouble", "Vista", "dashboard" },
                theme = require("ofirkai.statuslines.lualine").theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "filetype",
                    { "filename", path = 1 },
                },
                lualine_c = { "diagnostics" },
                lualine_x = {},
                lualine_y = {
                    "filesize",
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
                },
                lualine_z = { "location", "hostname" },
            },
            tabline = {
                lualine_a = { "tabs" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { {
                    "buffers",
                    mode = 2,
                } }
            }
        })
    end,
}
