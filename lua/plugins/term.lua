require("FTerm").setup({
    border = "double",
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
})
vim.keymap.set("n", "<A-t>", require("FTerm").toggle, { desc = "Fterm: toggle" })
vim.keymap.set("t", "<A-t>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Fterm: toggle" })
vim.keymap.set("t", "<c-esc>", "<C-\\><C-n>")

vim.api.nvim_create_autocmd("User", {
    pattern = "UnceptionEditRequestReceived",
    callback = function()
        require("FTerm").toggle()
    end,
})
