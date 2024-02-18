local M = {
    neofetch = "",
    version = "",
    plugins = "",
}

local function draw_footer(dashboard)
    local footer = {
        M.version,
        M.plugins,
    }
    if type(M.neofetch) ~= "string" then
        table.insert(footer, string.format("%s\t%s", M.neofetch["OS"], M.neofetch["Kernel"]))
        table.insert(footer, string.format("uptime: %s", M.neofetch["Uptime"]))
    end
    dashboard.section.footer.val = footer
    vim.cmd.AlphaRedraw()
end

local function run_neofetch(dashboard)
    local neofetch = vim.fn.executable("neofetch")
    if neofetch == 0 then
        return
    end

    local t = ""
    local stdout = function(error, data)
        if data then
            t = t .. data
        end
    end
    local on_exit = function(...)
        if #t > 0 then
            M.neofetch = vim.json.decode(t)
        end
        local timer = vim.uv.new_timer()

        timer:start(
            20,
            0,
            vim.schedule_wrap(function()
                draw_footer(dashboard)
            end)
        )
    end
    if vim.system then
        vim.system({ "neofetch", "--json" }, {
            text = true,
            stdout = stdout,
        }, on_exit)
    else
        require("plenary.job")
            :new({
                command = "neofetch",
                args = { "--json" },
                on_stdout = stdout,
                on_exit = on_exit,
            })
            :start()
    end
end

return {
    "goolord/alpha-nvim",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")

        local header = require("ascii").get_random_global()

        dashboard.config.layout[1].val = 1

        dashboard.section.header.val = header
        dashboard.section.buttons.val = {
            dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", " " .. " Find file", ":FzfLua files<cr>"),
            dashboard.button("s", " " .. " Search", ":FzfLua grep_project<cr>"),
            dashboard.button(
                "r",
                "󰄉 " .. " Recent files",
                ":lua require('fzf-lua').oldfiles({ multiprocess = true, cwd_only=true })<cr>"
            ),
            dashboard.button(
                "g",
                "󰄉 " .. " Git status",
                ":lua require('fzf-lua').git_status({ multiprocess = true })<cr>"
            ),
            dashboard.button("c", " " .. " Config", ":e .nvim.lua <CR>"),
            dashboard.button("u", "󰊳 " .. " Update Plugins", ":Lazy update<CR>"),
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
        return dashboard
    end,
    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
        local ft = vim.filetype.match({ buf = 0 })
        if ft == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)
        run_neofetch(dashboard)
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                M.version = "󰥱 v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
                M.plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"

                draw_footer(dashboard)
            end,
        })
    end,
    dependencies = {
        "nvim-web-devicons",
        "JMarkin/ascii.nvim",
    },
}
