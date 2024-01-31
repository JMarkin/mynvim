table.unpack = table.unpack or unpack
vim.uv = vim.loop

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
if not vim.uv.fs_stat(lazypath) then
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
    change_detection = {
        notify = true,
    },
    dev = {
        path = "~/projects",
        patterns = {},
        fallback = true, -- Fallback to git when local plugin doesn't exist
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
            ---@type string[]
            paths = {}, -- add any custom paths here that you want to includes in the rtp
            ---@type string[] list any plugins you want to disable here
            disabled_plugins = {
                -- "gzip",
                "matchit",
                "matchparen",
                -- "netrwPlugin",
                -- "tarPlugin",
                "tohtml",
                "tutor",
                -- "zipPlugin",
            },
        },
    },
})
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
        require("profile").start("*")
    else
        require("profile").instrument("*")
    end
end
