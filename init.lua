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
require("funcs")
require("au")

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

require("lazy").setup({ import = "plugins" }, {
    checker = {
        notify = false,
    },
    change_detection = {
        notify = false,
    },
})
require("ofirkai")
