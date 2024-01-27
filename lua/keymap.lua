vim.keymap.set({ "n" }, { "<leader>q", "<space>q" }, ":q<cr>", { desc = "Quit" })
vim.keymap.set({ "n", "v" }, "<C-e>", "<C-u>")

vim.keymap.set({ "n" }, "o", "o<Esc>", { desc = "Add line under" })
vim.keymap.set({ "n" }, "O", "O<Esc>", { desc = "Add line prev" })
vim.keymap.set({ "v" }, "p", "pgvy", { desc = "Disable yank on paste" })

vim.keymap.set({ "n" }, { "<leader>w", "<leader>'" }, ":w<CR>", { silent = true, desc = "normal mode: save" })
vim.keymap.set(
    { "v" },
    { "<leader>w", "<leader>'" },
    "<Esc>:w<CR>",
    { desc = "visual mode: escape to normal and save" }
)

vim.keymap.set({ "n" }, { "<leader>W" }, ":wa<CR>", { silent = true, desc = "normal mode: save" })
vim.keymap.set({ "v" }, { "<leader>W" }, "<Esc>:wa<CR>", { desc = "visual mode: escape to normal and save" })

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

-- ins-completion shortmaps
-- h ins-completion
vim.cmd([[
inoremap <C-L> <C-X><C-L>
inoremap <C-N> <C-X><C-N>
inoremap <C-K> <C-X><C-K>
inoremap <C-T> <C-X><C-T>
inoremap <C-I> <C-X><C-I>
inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-U> <C-X><C-U>
inoremap <C-O> <C-X><C-O>
inoremap <C-s> <C-X><C-s>
inoremap <C-z> <C-N><C-P>
]])

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr('$')
    if num_tabs >= count then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end
vim.keymap.set({ 'n', 'x' }, 'gt', tabswitch(vim.cmd.tabnext))
vim.keymap.set({ 'n', 'x' }, 'gT', tabswitch(vim.cmd.tabprev))
vim.keymap.set({ 'n', 'x' }, 'gy', tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

vim.keymap.set({ 'n', 'x' }, '<space>0', '<Cmd>0tabnew<CR>')
vim.keymap.set({ 'n', 'x' }, '<space>1', tabswitch(vim.cmd.tabnext, 1))
vim.keymap.set({ 'n', 'x' }, '<space>2', tabswitch(vim.cmd.tabnext, 2))
vim.keymap.set({ 'n', 'x' }, '<space>3', tabswitch(vim.cmd.tabnext, 3))
vim.keymap.set({ 'n', 'x' }, '<space>4', tabswitch(vim.cmd.tabnext, 4))
vim.keymap.set({ 'n', 'x' }, '<space>5', tabswitch(vim.cmd.tabnext, 5))
vim.keymap.set({ 'n', 'x' }, '<space>6', tabswitch(vim.cmd.tabnext, 6))
vim.keymap.set({ 'n', 'x' }, '<space>7', tabswitch(vim.cmd.tabnext, 7))
vim.keymap.set({ 'n', 'x' }, '<space>8', tabswitch(vim.cmd.tabnext, 8))
vim.keymap.set({ 'n', 'x' }, '<space>9', tabswitch(vim.cmd.tabnext, 9))


