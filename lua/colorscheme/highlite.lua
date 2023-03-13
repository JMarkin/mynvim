local highlite = require("highlite")

local configure_group = require("colorscheme.group")
local colors = require("colorscheme.colors")

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local _group = configure_group(colors)
        for _, v in pairs(_group) do
            v["style"] = nil
        end
        highlite.highlight_all(_group)
    end,
    group = vim.api.nvim_create_augroup("config", { clear = true }),
    pattern = "highlite",
})

vim.cmd("colorscheme highlite")
