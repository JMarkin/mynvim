local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end


return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            extensions = { "quickfix", "nvim-tree", "fzf", "lazy", "symbols-outline", "nvim-dap-ui", "toggleterm" },
            options = {
                disabled_filetypes = { "Trouble", "Vista", "dashboard" },
                theme = require("ofirkai.statuslines.lualine").theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    { 'diff',     source = diff_source },
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
                    "windows",
                    mode = 2,
                    disabled_buftypes = { 'prompt' },
                } }
            }
        })
    end,
}
