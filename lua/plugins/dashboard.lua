local M = {}

M.plugin = {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
        require("dashboard.theme.header").generate_header = function(config)
            if not vim.bo[config.bufnr].modifiable then
                vim.bo[config.bufnr].modifiable = true
            end
            if not config.command then
                local header = require("ascii").get_random_global()
                vim.api.nvim_buf_set_lines(config.bufnr, 0, -1, false, require("dashboard.utils").center_align(header))

                for i, _ in ipairs(header) do
                    vim.api.nvim_buf_add_highlight(config.bufnr, 0, "DashboardHeader", i - 1, 0, -1)
                end
                return
            end
        end

        local shortcuts = {
            { desc = " Update", group = "@property", action = "Lazy update", key = "u" },
            {
                icon = " ",
                icon_hl = "@variable",
                desc = "Files",
                group = "Label",
                action = "lua require('fzf-lua').files({ multiprocess=true,})",
                key = "f",
            },
            {
                icon = " ",
                desc = "Recent Files",
                group = "DiagnosticHint",
                action = "lua require('fzf-lua').oldfiles({ multiprocess = true, cwd_only=true })",
                key = "r",
            },
            {
                desc = "  Local Configuration",
                group = "Number",
                action = ":e .vimrc.lua",
                key = "c",
            },
        }
        vim.o.showtabline = 1
        require("dashboard").setup({
            theme = "doom",
            config = {
                project = { enable = false, limit = 8, icon = " ", label = "", action = ":FzfLua files cwd=" },
                shortcut = shortcuts,
                center = shortcuts,
                footer = {},
            },
            hide = {
                statusline = true,
                tabline = false,
            },
        })
    end,
    dependencies = {
        { "nvim-web-devicons" },
        {
            "MaximilianLloyd/ascii.nvim",
            dependencies = { "MunifTanjim/nui.nvim" },
        },
    },
}

return M
