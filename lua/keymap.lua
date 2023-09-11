vim.keymap.set({ "n" }, { "<leader>q", "<space>q" }, ":q<cr>", { desc = "Quit" })

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

vim.keymap.set("n", "<leader>tn", ":$tabnew<CR>", { desc = "Tabs: new" })
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", { desc = "Tabs: close" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Tabs: close other tabs" })
vim.keymap.set("n", "<leader>tmp", ":-tabmove<CR>", { desc = "Tabs: move to prev" })
vim.keymap.set("n", "<leader>tmn", ":+tabmove<CR>", { desc = "Tabs: move to next" })

vim.api.nvim_create_user_command("LspInstallDefault", function(_)
    require("lsp").install()
end, {})

vim.api.nvim_create_user_command("LspInstallDefaultSync", function(_)
    require("lsp").install(true)
end, {})

vim.api.nvim_create_user_command("TSInstallDefault", function(_)
    require("plugins.treesitter").install()
end, {})

vim.api.nvim_create_user_command("TSInstallDefaultSync", function(_)
    require("plugins.treesitter").install(true)
end, {})


vim.api.nvim_create_user_command("NullInstallDefault", function(_)
    require("plugins.nullls").install()
end, {})

vim.api.nvim_create_user_command("NullInstallDefaultSync", function(_)
    require("plugins.nullls").install(true)
end, {})

vim.api.nvim_create_user_command("InstallDefault", function(_)
    require("plugins.nullls").install(true)
    require("lsp").install(true)
    require("plugins.treesitter").install()
end, {})