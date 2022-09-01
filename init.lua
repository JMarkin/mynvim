vim.g.python_host_prog = vim.env.PYTHON2
vim.g.python3_host_prog = vim.env.PYTHON3

local present, _ = pcall(require, "impatient")
if not present then
	print("Impations not install run :PackerInstall")
end
require("settings")
require("plugins")
require("plugins.colors")()
