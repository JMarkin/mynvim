require("neogen").setup({
    enabled = true,
    input_after_comment = true,
    snippet_engine = "luasnip",
})

vim.keymap.set("n", "<leader>ld", "<cmd>Neogen<cr>", { silent = true, desc = "Lang: generete docs" })
