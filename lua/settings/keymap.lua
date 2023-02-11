vim.keymap.set({ "n" }, { "<leader>q", "<space>q" }, ":q<cr>", { desc = "Quit" })

---------Тогл Инструментов
vim.keymap.set({ "n" }, "<space>f", "<Cmd>NvimTreeOpen<CR>", { desc = "FileTree" })
vim.keymap.set({ "n" }, "<space>E", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "All Diagnostics" })
vim.keymap.set({ "n" }, "<space>e", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set({ "n" }, "<space>G", "<Cmd>LazyGit<CR>", { desc = "Git: lazygit" })
vim.keymap.set({ "n" }, "<space>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Git: blame" })

-- Visual
vim.keymap.set({ "n" }, "<C-A>", "ggVG", { desc = "Visual all" })
vim.keymap.set({ "n" }, "o", "o<Esc>", { desc = "Add line under" })
vim.keymap.set({ "n" }, "O", "O<Esc>", { desc = "Add line prev" })

--save shortcut
vim.keymap.set({ "n" }, { "<leader>w", "<leader>'" }, ":w<CR>", { silent = true, desc = "normal mode: save" })
vim.keymap.set({ "i" }, "<C-s>", "<Esc>:w<CR>l", { silent = true, desc = "insert mode: escape to normal and save" })
vim.keymap.set(
    { "t" },
    { "<leader>w", "<leader>'" },
    "<Esc>:w<CR>",
    { desc = "visual mode: escape to normal and save" }
)
