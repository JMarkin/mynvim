return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            background_colour = require("ofirkai").scheme.ui_bg,
            max_width = 80,
            timeout = 1000,
            stages = "static",
            level = vim.log.levels.INFO,
        })
        vim.notify = require("notify")
    end,
    lazy = false,
    priority = 1000,
    dependencies = {
        "ofirgall/ofirkai.nvim",
    },
}
