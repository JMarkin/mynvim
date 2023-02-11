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

vim.keymap.set("n", "tt", function()
    require("neotest").run.run()
end, { desc = "Tests: run nearest test" })
vim.keymap.set("n", "ts", function()
    require("neotest").run.stop()
end, { desc = "Tests: stop nearest test" })
vim.keymap.set("n", "ta", function()
    require("neotest").run.attach()
end, { desc = "Tests: attach nearest test" })
vim.keymap.set("n", "tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Tests: run current file" })
