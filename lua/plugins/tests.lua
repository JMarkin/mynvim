local M = {}

local is_not_mini = require("custom.funcs").is_not_mini
M.plugin = {
    "nvim-neotest/neotest",
    cond = is_not_mini,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "rouge8/neotest-rust",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    args = { "--log-level", "DEBUG" },
                    runner = vim.g.python_test_runner or "pytest",
                }),
                require("neotest-rust")({}),
            },
        })

        vim.keymap.set("n", "<leader>ltt", function()
            require("neotest").run.run()
        end, { desc = "Tests: run nearest test" })
        vim.keymap.set("n", "<leader>lts", function()
            require("neotest").run.stop()
        end, { desc = "Tests: stop nearest test" })
        vim.keymap.set("n", "<leader>lta", function()
            require("neotest").run.attach()
        end, { desc = "Tests: attach nearest test" })
        vim.keymap.set("n", "<leader>ltf", function()
            require("neotest").run.run(vim.fn.expand("%"))
        end, { desc = "Tests: run current file" })
    end,
    ft = { "python", "rust" },
    cmd = { "Neotest" },
}

return M
