local highlite = require("highlite")

local group = require("colorscheme.group")

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        highlite.highlight_all(group)
    end,
    group = vim.api.nvim_create_augroup("config", { clear = true }),
    pattern = "highlite",
})

vim.cmd("colorscheme highlite")
