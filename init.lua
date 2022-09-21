vim.g.cursorhold_updatetime = 100
vim.g.python_host_prog = vim.env.PYTHON2
vim.g.python3_host_prog = vim.env.PYTHON3
vim.g.snips_author = vim.env.AUTHOR or 'Jury Markin'
vim.g.snips_email = vim.env.EMAIL or 'me@jmarkin.ru'
vim.g.snips_github = vim.env.EMAIL or 'https://github.com/JMarkin'

local present, _ = pcall(require, "impatient")
if not present then
    print("Impations not install run :PackerInstall")
end
require("settings")
require("plugins")
