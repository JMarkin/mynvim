local M = {}

local is_not_mini = require("custom.funcs").is_not_mini
local ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "jsonls",
    "yamlls",
    "html",
    "marksman",
    "taplo",
    "volar",
    "vimls",
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "gopls",
    "jedi_language_server@0.39.0",
}

M.format = function()
    vim.lsp.buf.format({
        filter = function(client)
            if require("plugins.nullls").enabled then
                return client.name == "null-ls" or client.name == "rust_analyzer"
            end
            return true
        end,
        async = true,
    })
end

M.plugin = {
    "williamboman/mason.nvim",
    cond = is_not_mini,
    lazy = true,
    dependencies = {
        {
            "neovim/nvim-lspconfig",
        },
        {
            "williamboman/mason-lspconfig.nvim",
        },
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
    },
    config = function()
        local setup_lsp = require("plugins.lsp.lang").setup_lsp

        require("mason").setup()
        require("mason-lspconfig").setup({})
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                local s_lsp = M[server_name]
                if s_lsp == nil or s_lsp == "" then
                    -- vim.notify("default config for " .. server_name, vim.log.levels.DEBUG)
                    setup_lsp(server_name, {})
                else
                    s_lsp()
                end
            end,
        })

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
    cmd = "Mason",
}

M.install = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
    })
    require("mason-lspconfig.ensure_installed")()
end

return M
