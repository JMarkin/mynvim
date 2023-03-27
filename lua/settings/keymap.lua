vim.keymap.set({ "n" }, { "<leader>q", "<space>q" }, ":q<cr>", { desc = "Quit" })

vim.keymap.set({ "n" }, "<space>f", "<Cmd>NvimTreeOpen<CR>", { desc = "FileTree" })
vim.keymap.set({ "n" }, "<space>E", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "All Diagnostics" })
vim.keymap.set({ "n" }, "<space>e", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Buffer Diagnostics" })

-- Visual
vim.keymap.set({ "n" }, "<C-A>", "ggVG", { desc = "Visual all" })
vim.keymap.set({ "n" }, "o", "o<Esc>", { desc = "Add line under" })
vim.keymap.set({ "n" }, "O", "O<Esc>", { desc = "Add line prev" })
vim.keymap.set({ "v" }, "p", "pgvy", { desc = "Disable yank on paste" })

vim.keymap.set({ "n" }, { "<leader>w", "<leader>'" }, ":w<CR>", { silent = true, desc = "normal mode: save" })
vim.keymap.set({ "i" }, "<C-s>", "<Esc>:w<CR>l", { silent = true, desc = "insert mode: escape to normal and save" })
vim.keymap.set(
    { "t" },
    { "<leader>w", "<leader>'" },
    "<Esc>:w<CR>",
    { desc = "visual mode: escape to normal and save" }
)

vim.keymap.set("t", "<c-esc>", "<C-\\><C-n>")

-- Keymaps
vim.keymap.set({ "n", "o", "x" }, "w", function()
    require("spider").motion("w")
end, { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", function()
    require("spider").motion("e")
end, { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", function()
    require("spider").motion("b")
end, { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", function()
    require("spider").motion("ge")
end, { desc = "Spider-ge" })
