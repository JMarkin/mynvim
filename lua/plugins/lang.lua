return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "FileReadPre" },
        enabled = true,
        config = function()
            require("lint").linters_by_ft = {
                sql = { "sqlfluff" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "FileReadPost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "sbdchd/neoformat",
        enabled = true,
        keys = {
            { "<space>bf", "<cmd>Neoformat<cr>", desc = "Format buffer" },
        },
        config = function()
            vim.g.neoformat_run_all_formatters = 1
            vim.g.neoformat_only_msg_on_error = 0
            vim.g.neoformat_basic_format_align = 1
            vim.g.neoformat_basic_format_retab = 1
            vim.g.neoformat_basic_format_trim = 1

            vim.g.neoformat_enabled_python = { "ruff" }
            vim.g.neoformat_enabled_nginx = { "nginxbeautifier" }
            vim.g.neoformat_enabled_rust = { "rustfmt" }
            vim.g.neoformat_enabled_toml = { "taplo" }
            vim.g.neoformat_enabled_json = { "fixjson" }
            vim.g.neoformat_enabled_lua = { "stylua" }

            vim.g.neoformat_sql_sqlfluff = {
                exe = "sqlfluff",
                args = { "format", "--dialect", "postgres", "-" },
                stdin = 1,
            }
            vim.g.neoformat_enabled_sql = { "sqlfluff" }

            for _, lang in ipairs({ "markdown", "javascript", "typescript", "html", "css", "yaml", "scss", "vue" }) do
                vim.g["neoformat_enabled_" .. lang] = { "prettierd" }
            end
        end,
    },
}
