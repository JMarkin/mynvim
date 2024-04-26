local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            extensions = { "quickfix", "nvim-tree", "fzf", "lazy", "symbols-outline", "nvim-dap-ui", "toggleterm" },
            options = {
                disabled_filetypes = { "Trouble", "Vista", "dashboard" },
                theme = vim.g.lualine_theme or "auto",
                component_separators = { left = " ", right = " " },
                globalstatus = true,
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
                lualine_b = {
                    { "branch", icon = "" },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = "󰝶 ",
                        },
                    },
                    -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    -- { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                },
                lualine_x = {
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                    },
                    { "diff", source = diff_source },
                },
                lualine_y = {
                    "encoding",
                    "filesize",
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
                lualine_a = {
                    -- замедляют переключение
                    {
                        "windows",
                        mode = 2,
                        disabled_buftypes = { "prompt" },
                    },
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {
                    {
                        "tabs",
                        mode = 2,
                    },
                },
            },
        })
    end,
}
