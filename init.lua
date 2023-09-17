require("common")
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
require("keymap")

if vim.env.PYTHON3 then
    vim.g.python3_host_prog = vim.env.PYTHON3
end

vim.g.snips_author = vim.env.AUTHOR or "Jury Markin"
vim.g.snips_email = vim.env.EMAIL or "me@jmarkin.ru"
vim.g.snips_github = vim.env.EMAIL or "https://github.com/JMarkin"
vim.g.loaded_matchit = 1

if vim.g.neovide then
    require("neovide")
end


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

require("funcs")
require("au")

require("lazy").setup("plugins")
require("ofirkai")
