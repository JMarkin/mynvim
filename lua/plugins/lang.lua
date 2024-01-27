local is_not_mini = require("funcs").is_not_mini
return {
    {
        "nvimdev/guard.nvim",
        enabled = false,
        dev = true,
        dependencies = {
            {
                "nvimdev/guard-collection",
                -- dev = true,
            },
        },
        lazy = true,
        keys = {
            { "<space>bf", "<cmd>GuardFmt<cr>", desc = "Format buffer" },
        },
        config = function()
            local ft = require("guard.filetype")

            ft("python"):fmt("ruff")

            ft("lua"):fmt("stylua")

            ft("c,cpp"):lint("clang-tidy")

            ft("toml"):fmt("taplo")

            ft("typescript,javascript,typescriptreact,markdown"):fmt("prettier")

            require("guard").setup({
                -- the only options for the setup function
                fmt_on_save = false,
                lint_on_change = false,
                -- Use lsp if no formatter was defined for this filetype
                lsp_as_default_formatter = true,
            })
        end,
    },
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
            require("lint").linters_by_ft = {
                sql = { "sqlfluff" },
            }
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
            vim.g.neoformat_basic_format_align = 1
            vim.g.neoformat_basic_format_retab = 0
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
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
        cond = is_not_mini,
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
