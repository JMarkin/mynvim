local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
    group = augroup("http", { clear = true }),
    pattern = {
        "http",
    },
    callback = function(event)
        vim.keymap.set(
            "n",
            "<leader>hr",
            "<cmd>Rest run<cr>",
            { buffer = event.buf, silent = true, desc = "run the request under the cursor" }
        )
        vim.keymap.set(
            "n",
            "<leader>hp",
            "<Plug>RestNvimPreview",
            { buffer = event.buf, silent = true, desc = "preview the request cURL command" }
        )
        vim.keymap.set(
            "n",
            "<leader>hl",
            "<cmd>Rest run last<cr>",
            { buffer = event.buf, silent = true, desc = "re-run the last request" }
        )
    end,
})

return {
    "rest-nvim/rest.nvim",
    dependencies = { "luarocks.nvim" },
    ft = "http",
    keys = {
        "<leader>hr",
        "<leader>hp",
        "<leader>hl",
    },
    config = function()
        require("rest-nvim").setup()
    end,
}
