vim.g.cursorhold_updatetime = 100

vim.g.python3_host_prog = vim.env.PYTHON3
vim.g.snips_author = vim.env.AUTHOR or "Jury Markin"
vim.g.snips_email = vim.env.EMAIL or "me@jmarkin.ru"
vim.g.snips_github = vim.env.EMAIL or "https://github.com/JMarkin"

vim.g.loaded_matchit = 1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

local default_vim_keymap_set = vim.keymap.set

vim.keymap.set = function(mode, lhs, rhs, opts)
    if type(lhs) == "table" then
        for _, key in ipairs(lhs) do
            default_vim_keymap_set(mode, key, rhs, opts)
        end
    else
        default_vim_keymap_set(mode, lhs, rhs, opts)
    end
end

require("custom")
require("settings")
require("plugins")
