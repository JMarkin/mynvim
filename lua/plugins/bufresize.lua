local present, bufresize = pcall(require, "bufresize")

if not present then
	return
end

nnoremap("b<left>", "30<C-w><<cmd>lua require('bufresize').register()<cr>", "Buffer: resize left")
nnoremap("b<right>", "30<C-w>><cmd>lua require('bufresize').register()<cr>", "Buffer: resize right")

nnoremap("b<down>", "30<C-w>-<cmd>lua require('bufresize').register()<cr>", "Buffer: resize down")
nnoremap("b<up>", "30<C-w>+<cmd>lua require('bufresize').register()<cr>", "Buffer: resize up")

vim.cmd([[
augroup Resize
    autocmd!
    autocmd VimResized * lua require('bufresize').resize()
augroup END
]])
