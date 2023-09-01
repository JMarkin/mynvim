local M = {}

local is_not_mini = require("custom.funcs").is_not_mini

M.format = function()
    vim.lsp.buf.format({
        filter = function(client)
            if require("plugins.nullls").enabled then
                return client.name == "null-ls" or client.name == "rust_analyzer" or client.name == "clangd"
            end
            return true
        end,
        async = true,
    })
end

M.plugin = {
    "neovim/nvim-lspconfig",
    cond = is_not_mini,
    lazy = true,
    dependencies = {
        {
            "glepnir/lspsaga.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
            "j-hui/fidget.nvim",
            opts = {
                align = {
                    bottom = false, -- align fidgets along bottom edge of buffer
                    right = true, -- align fidgets along right edge of buffer
                },
            },
            tag = "legacy",
        },
        { "folke/neodev.nvim", opts = { lspconfig = false } },
    },
    config = function()
        require("lsp").setup()

        vim.diagnostic.config({
            underline = true,
            signs = true,
            virtual_text = false,
            -- virtual_lines = { only_current_line = true },
            float = true,
            update_in_insert = false,
            severity_sort = true,
        })

        require("plugins.lspsaga")
    end,
    event = { "BufReadPre", "FileReadPre" },
}

return M
