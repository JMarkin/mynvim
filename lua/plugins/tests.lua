local is_not_mini = require("funcs").is_not_mini
return {
    "nvim-neotest/neotest",
    cond = is_not_mini,
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "rouge8/neotest-rust",
    },
    keys = {
        {
            "<leader>T",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Tests",
        },
        {
            "<leader>to",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Tests: output",
        },
        {
            "<leader>tt",
            function()
                require("neotest").run.run()
            end,
            desc = "Tests: run nearest test",
        },
        {
            "<leader>ts",
            function()
                require("neotest").run.stop()
            end,
            desc = "Tests: stop nearest test",
        },
        {
            "<leader>ta",
            function()
                require("neotest").run.attach()
            end,
            desc = "Tests: attach nearest test",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Tests: run current file",
        },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    -- args = { "--log-level", "DEBUG", "--showlocals" },
                    runner = vim.g.python_test_runner or "pytest",
                }),
                require("neotest-rust")({}),
            },
        })
    end,
    cmd = { "Neotest" },
}
