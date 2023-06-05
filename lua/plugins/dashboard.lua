local M = {}

M.plugin = {
    "goolord/alpha-nvim",
    event = "VimEnter",
    lazy = true,
    opts = function()
        local dashboard = require("alpha.themes.dashboard")

        local header = require("ascii").get_random_global()

        dashboard.section.header.val = header
        dashboard.section.buttons.val = {
            dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", " " .. " Find file", ":lua require('fzf-lua').files({ multiprocess=true,})<cr>"),
            dashboard.button(
                "r",
                "󰄉 " .. " Recent files",
                ":lua require('fzf-lua').oldfiles({ multiprocess = true, cwd_only=true })<cr>"
            ),
            dashboard.button("c", " " .. " Config", ":e .vimrc.lua <CR>"),
            dashboard.button("u", " " .. " Update Plugins", ":Lazy update<CR>"),
            dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }

        -- set highlight
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 8
        return dashboard
    end,
    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                local version = "  󰥱 v"
                    .. vim.version().major
                    .. "."
                    .. vim.version().minor
                    .. "."
                    .. vim.version().patch
                local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                local footer = version .. "\t" .. plugins .. "\n"
                dashboard.section.footer.val = footer
                pcall(vim.cmd.AlphaRedraw)
            end,
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
