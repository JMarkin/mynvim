return {
    "glacambre/firenvim",

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463
    lazy = not vim.g.started_by_firenvim,
    build = function()
        vim.fn["firenvim#install"](0)
    end,
    config = function()
        vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h10"
        vim.g.firenvim_config = {
            -- config values, like in my case:
            localSettings = {
                [".*"] = {
                    takeover = "never",
                },
            },
        }
        vim.o.laststatus = 0
    end,
}
