vim.o.timeout = true
vim.o.timeoutlen = 300

require("langmapper").setup({})
require("langmapper").automapping({ global = true, buffer = true })
local lmu = require("langmapper.utils")
local view = require("which-key.view")
local execute = view.execute

-- wrap `execute()` and translate sequence back
view.execute = function(prefix_i, mode, buf)
    -- Translate back to English characters
    prefix_i = lmu.translate_keycode(prefix_i, "default", "ru")
    execute(prefix_i, mode, buf)
end

local presets = require("which-key.plugins.presets")
presets.objects = lmu.trans_dict(presets.objects)
presets.motions = lmu.trans_dict(presets.motions)

local wk = require("which-key")

wk.setup({
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "  ", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },

    window = {
        border = "shadow", -- none/single/double/shadow
    },

    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },

    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        i = { "j", "k" },
        v = { "j", "k" },
    },
    plugins = {
        presets = {
            operators = false,
        },
    },
})

wk.register({
    ["<leader>t"] = { name = "Tabs" },
    ["<leader>l"] = { name = "Lang" },
    ["<leader>g"] = { name = "Git" },
    ["<leader>s"] = { name = "Search" },
    ["<leader>d"] = { name = "Debug" },
    ["<space>b"] = { name = "Buffers" },
    ["<leader>b"] = { name = "Bookmark" },
})
