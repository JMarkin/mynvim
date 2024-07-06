-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

table.unpack = table.unpack or unpack
if not vim.uv then
    vim.uv = vim.loop
end

require("common")
require("indent")
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
require("term")
require("netrw_")
require("ai")

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
    concurrency = 10,
    change_detection = {
        enabled = false,
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
                -- "tohtml",
                "tutor",
                -- "zipPlugin",
            },
        },
    },
    profiling = {
        -- Enables extra stats on the debug tab related to the loader cache.
        -- Additionally gathers stats about all package.loaders
        loader = false,
        -- Track each new require in the Lazy profiling tab
        require = false,
    },
    pkg = {
        enabled = true,
        cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
        -- the first package source that is found for a plugin will be used.
        sources = {
            "lazy",
            "rockspec", -- will only be used when rocks.enabled is true
            "packspec",
        },
    },
    rocks = {
        enabled = true,
        hererocks = true,
        root = vim.fn.stdpath("data") .. "/lazy-rocks",
        server = "https://nvim-neorocks.github.io/rocks-binaries/",
    },
})
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
    vim.cmd([[
        profile start profile.log
        profile func *
        profile file *
    ]])
    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
        require("profile").start("*")
    else
        require("profile").instrument("*")
    end
end
