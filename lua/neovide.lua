vim.g.neovide_transparency = 0.95
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_window_blurred = true
vim.g.neovide_remember_window_size = false
vim.g.neovide_input_use_logo = 1

vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
vim.keymap.set("v", "<D-c>", '"+y') -- Copy
vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-v>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-v>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-v>", { noremap = true, silent = true })

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-+>", function()
    change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
end)

vim.cmd([[
    map ˙ <a-h>
    map ∆ <a-j>
    map ˚ <a-k
    map ¬ <a-l>
    map ƒ <a-f>
    map © <a-g>
    tmap © <a-g>
    map † <a-t>
    tmap † <a-t>
    map ∫ <a-b>
    tmap ∫ <a-b>
    map ˆ <a-i>
    tmap ˆ <a-i>
]])
