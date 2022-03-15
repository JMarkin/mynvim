vim.g.python_host_prog = vim.env.PYTHON2
vim.g.python3_host_prog = vim.env.PYTHON3

local present, impatient = pcall(require, "impatient")
if not present then
	print("Impations not install run :PackerInstall")
end
require("settings")
require("plugins")

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
