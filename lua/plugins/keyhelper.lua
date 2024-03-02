return {
    {
        "echasnovski/mini.clue",
        event = "VimEnter",
        -- enabled = false,
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                window = {
                    delay = 300,
                },
                triggers = {

                    -- motion triggers
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },

                    -- space triggers
                    { mode = "n", keys = "<space>" },

                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),

                    { mode = "n", keys = "gz", desc = "Surround" },
                    { mode = "n", keys = "<space>s", desc = "Scratch" },
                    { mode = "n", keys = "<space>b", desc = "Buffers" },
                    { mode = "n", keys = "<leader>b", desc = "Bookmark" },
                    { mode = "n", keys = "<Leader>l", desc = "Lang" },
                    { mode = "n", keys = "<Leader>g", desc = "Git" },
                    { mode = "v", keys = "<Leader>g", desc = "Git" },
                    { mode = "n", keys = "<Leader>s", desc = "Search" },
                    { mode = "v", keys = "<Leader>s", desc = "Search" },
                    { mode = "n", keys = "<Leader>d", desc = "Debug" },
                    { mode = "v", keys = "<Leader>d", desc = "Debug" },
                    { mode = "n", keys = "<Leader>s", desc = "Search" },
                    { mode = "n", keys = "<Leader>lc", desc = "Copy as" },
                    { mode = "n", keys = "<Leader>lt", desc = "Tests" },
                    { mode = "n", keys = "<Leader>h", desc = "Http" },
                },
            })
        end,
    },
}
