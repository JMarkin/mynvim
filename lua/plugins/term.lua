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
vim.keymap.set("t", "<c-esc>", "<C-\\><C-n>")

vim.api.nvim_create_autocmd("User", {
    pattern = "UnceptionEditRequestReceived",
    callback = function()
        print("Hello world!")
        fterm.toggle()
    end,
})

local gitui = fterm:new({
    ft = "fterm_gitui",
    cmd = "gitui",
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
})

vim.keymap.set("n", "<A-g>", function()
    gitui:toggle()
end)

local btop = fterm:new({
    ft = "fterm_btop",
    cmd = "btop",
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
})

vim.keymap.set("n", "<A-b>", function()
    btop:toggle()
end)
