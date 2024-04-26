local is_not_mini = require("funcs").is_not_mini
vim.g.linter_by_ft = {
    sql = { "sqlfluff" },
    jinja = { "djlint" },
    htmldjango = { "djlint" },
    python = { "mypy" },
}

return {
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        enabled = true,
        init = function()
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "FileReadPost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
        config = function()
            require("lint").linters_by_ft = vim.g.linter_by_ft
        end,
    },
    {
        "sbdchd/neoformat",
        enabled = true,
        keys = {
            { "<space>bf", "<cmd>Neoformat<cr>", desc = "Format buffer" },
        },
        init = function()
            vim.g.neoformat_run_all_formatters = 1
            vim.g.neoformat_only_msg_on_error = 0
            vim.g.neoformat_basic_format_align = 0
            vim.g.neoformat_basic_format_retab = 0
            vim.g.neoformat_basic_format_trim = 1

            vim.g.neoformat_enabled_python = { "ruff" }
            vim.g.neoformat_enabled_nginx = { "nginxbeautifier" }
            vim.g.neoformat_enabled_rust = { "rustfmt" }
            vim.g.neoformat_enabled_toml = { "taplo" }
            vim.g.neoformat_enabled_json = { "fixjson" }
            vim.g.neoformat_enabled_lua = { "stylua" }
            vim.g.neoformat_enabled_jinja = { "djlint" }
            vim.g.neoformat_jinja_djlint = {
                exe = "djlint",
                args = { "-", "--reformat" },
                stdin = 1,
            }
            vim.g.neoformat_enabled_htmldjango = { "djlint" }

            vim.g.neoformat_sql_sqlfluff = {
                exe = "sqlfluff",
                args = { "format", "--dialect", "postgres", "-" },
                stdin = 1,
            }
            vim.g.neoformat_enabled_sql = { "sqlfluff" }

            for _, lang in ipairs({
                "javascript",
                "typescript",
                "jsx",
                "tsx",
                "jsonc",
            }) do
                vim.g["neoformat_enabled_" .. lang] = { "biome" }
            end
            for _, lang in ipairs({
                "markdown",
                "html",
                "css",
                "yaml",
                "scss",
                "vue",
            }) do
                vim.g["neoformat_enabled_" .. lang] = { "prettier" }
            end
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
        cond = is_not_mini,
        -- enabled = false,
    },
    {
        name = "clangd_extenstions",
        url = "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        cond = is_not_mini,
        lazy = true,
    },
    { "b0o/schemastore.nvim", cond = is_not_mini, lazy = true },
    {
        "ranelpadon/python-copy-reference.vim",
        cond = is_not_mini,
        ft = { "python" },
        keys = {
            {
                "<leader>lcd",
                ":PythonCopyReferenceDotted<CR>",
                desc = "Copy as: ReferenceDotted",
            },
            {
                "<leader>lcp",
                ":PythonCopyReferencePytest<CR>",
                desc = "Copy as: ReferencePytest",
            },
        },
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter",
        },
    },
    -- uncompiler
    {
        "p00f/godbolt.nvim",
        config = function()
            require("godbolt").setup()
        end,
        cmd = { "Godbolt", "GodboltCompiler" },
    },
}
