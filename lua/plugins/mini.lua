return {
    {
        "echasnovski/mini.clue",
        event = "VeryLazy",
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                window = {
                    delay = 300,
                },
                triggers = {
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

                    { mode = "n", keys = "<space>s",  desc = "Scratch" },
                    { mode = "n", keys = "<space>b",  desc = "Buffers" },
                    { mode = "n", keys = "<leader>b", desc = "Bookmark" },
                    { mode = "n", keys = "<Leader>t", desc = "Tabs" },
                    { mode = "n", keys = "<Leader>l", desc = "Lang" },
                    { mode = "n", keys = "<Leader>g", desc = "Git" },
                    { mode = "v", keys = "<Leader>g", desc = "Git" },
                    { mode = "n", keys = "<Leader>s", desc = "Search" },
                    { mode = "v", keys = "<Leader>s", desc = "Search" },
                    { mode = "n", keys = "<Leader>d", desc = "Debug" },
                    { mode = "v", keys = "<Leader>d", desc = "Debug" },
                    { mode = "n", keys = "<Leader>s", desc = "Search" },
                },
            })
        end,
    },
    -- Fast and feature-rich surround actions. For text that includes
    -- surrounding characters like brackets or quotes, this allows you
    -- to select the text inside, change or modify the surrounding characters,
    -- and more.
    {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.find,           desc = "Find right surrounding" },
                { opts.mappings.find_left,      desc = "Find left surrounding" },
                { opts.mappings.highlight,      desc = "Highlight surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gza",            -- Add surrounding in Normal and Visual modes
                delete = "gzd",         -- Delete surrounding
                find = "gzf",           -- Find surrounding (to the right)
                find_left = "gzF",      -- Find surrounding to the left
                highlight = "gzh",      -- Highlight surrounding
                replace = "gzr",        -- Replace surrounding
                update_n_lines = "gzn", -- Update `n_lines`
            },
        },
    },
    { "echasnovski/mini.pairs",     event = "VeryLazy",                       opts = {} },
    {
        "echasnovski/mini.ai",
        event = "ModeChanged",
        keys = { "g" },
        dependencies = { "nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 200,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
        end,
    },
    { "echasnovski/mini.splitjoin", keys = { { "gS", desc = "Split/Join" } }, opts = {} },
}
