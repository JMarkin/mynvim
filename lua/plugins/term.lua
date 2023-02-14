local fterm = require("FTerm")

fterm.setup({
    border = "double",
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
})
vim.keymap.set("n", "<A-t>", fterm.toggle, { desc = "Fterm: toggle" })
vim.keymap.set("t", "<A-t>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Fterm: toggle" })

vim.api.nvim_create_autocmd("User", {
    pattern = "UnceptionEditRequestReceived",
    callback = function()
        fterm.toggle()
    end,
})

local gitui = nil
local gitui_init = function()
    if gitui ~= nil then
        gitui:toggle()
    else
        gitui = fterm:new({
            ft = "fterm_gitui",
            cmd = "gitui",
            dimensions = {
                height = 0.9,
                width = 0.9,
            },
        })
        gitui:toggle()
    end
end

vim.keymap.set("n", "<A-g>", gitui_init, { desc = "Git" })

vim.api.nvim_create_user_command("Git", gitui_init, { bang = true })

local btop = nil

vim.keymap.set("n", "<A-b>", function()
    if btop ~= nil then
        btop:toggle()
    else
        btop = fterm:new({
            ft = "fterm_btop",
            cmd = "btop",
            dimensions = {
                height = 0.9,
                width = 0.9,
            },
        })
        btop:toggle()
    end
end)
