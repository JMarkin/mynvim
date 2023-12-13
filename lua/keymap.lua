vim.keymap.set({ "n" }, { "<leader>q", "<space>q" }, ":q<cr>", { desc = "Quit" })

-- Visual
vim.keymap.set({ "n" }, "o", "o<Esc>", { desc = "Add line under" })
vim.keymap.set({ "n" }, "O", "O<Esc>", { desc = "Add line prev" })
vim.keymap.set({ "v" }, "p", "pgvy", { desc = "Disable yank on paste" })

vim.keymap.set({ "n" }, { "<leader>w", "<leader>'" }, ":w<CR>", { silent = true, desc = "normal mode: save" })
vim.keymap.set({ "i" }, "<C-s>", "<Esc>:w<CR>l", { silent = true, desc = "insert mode: escape to normal and save" })
vim.keymap.set(
    { "v" },
    { "<leader>w", "<leader>'" },
    "<Esc>:w<CR>",
    { desc = "visual mode: escape to normal and save" }
)

vim.keymap.set("t", "<c-esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>tn", ":$tabnew<CR>", { desc = "Tabs: new" })
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", { desc = "Tabs: close" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Tabs: close other tabs" })
vim.keymap.set("n", "<leader>tmp", ":-tabmove<CR>", { desc = "Tabs: move to prev" })
vim.keymap.set("n", "<leader>tmn", ":+tabmove<CR>", { desc = "Tabs: move to next" })

vim.api.nvim_create_user_command("InstallDefault", function(_)
    vim.cmd.TSInstallDefault()
    require("lsp").install()
    vim.cmd.ExternalInstallDefault()
end, {})

vim.api.nvim_create_user_command("UpdateDefault", function(_)
    vim.cmd.TSInstallDefault()
    require("lsp").install(false, true)
    vim.cmd.ExternalUpdateDefault()
end, {})

vim.api.nvim_create_user_command("UnicodeUndoEscape", function(_)
    vim.cmd([[:%s/\\u\(\x\{4\}\)/\=nr2char('0x'.submatch(1),1)/g]])
end, {})
