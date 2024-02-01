vim.g.neovide_transparency = 0.95
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_window_blurred = true
vim.g.neovide_remember_window_size = false
vim.g.neovide_input_use_logo = 1

-- stylua: ignore start
vim.cmd([[
    cmap <D-v> <C-r>+
    map <D-v> "+p<CR>
    map! <D-v> <C-R>+
    tmap <D-v> <C-v>
    vmap <D-c> "+y<CR>

    map ˙ <a-h>
    map ∆ <a-j>
    map ˚ <a-k>
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
-- stylua: ignore end

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    vim.cmd(":redraw!")
end
vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(0.25)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(-0.25)
end)
