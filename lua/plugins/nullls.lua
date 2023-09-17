local is_not_mini = require("funcs").is_not_mini
local external_install = require("external_install")


local function exist_exec(exec)
    local function condition(...)
        return vim.fn.executable(exec) == 1
    end
end


local install = function(sync)
    local sources = {}
    vim.list_extend(sources, vim.g.diagnostic)
    vim.list_extend(sources, vim.g.formatters)
    for _, source in ipairs(sources) do
        external_install(source, sync)
    end
end

vim.api.nvim_create_user_command("NullInstallDefault", function(_)
    install()
end, {})

vim.api.nvim_create_user_command("NullInstallDefaultSync", function(_)
    install(true)
end, {})

return {
    "JMarkin/null-ls.nvim",
    -- dev = true,
    -- dir = "~/projects/null-ls.nvim",
    cond = is_not_mini,
    event = { "BufReadPre", "FileReadPre" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "CKolkey/ts-node-action",
            dependencies = { "nvim-treesitter" },
            opts = {},
        },
        {
            "ThePrimeagen/refactoring.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
            config = function()
                require("refactoring").setup()
            end,
        },
    },
    config = function()
        local nullls = require("null-ls")

        nullls.builtins.diagnostics.ruff = nullls.builtins.diagnostics.ruff.with({
            extra_args = { "--line-length", "120" },
        })
        nullls.builtins.formatting.ruff = nullls.builtins.formatting.ruff.with({
            extra_args = { "--line-length", "120" },
        })
        nullls.builtins.diagnostics.djlint = nullls.builtins.diagnostics.djlint.with({
            filetypes = { "jinja.html", "htmldjango" },
        })
        nullls.builtins.formatting.djlint = nullls.builtins.formatting.djlint.with({
            filetypes = { "jinja.html", "htmldjango" },
        })
        nullls.builtins.diagnostics.sqlfluff = nullls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "postgres" },
        })
        nullls.builtins.formatting.sqlfluff = nullls.builtins.formatting.sqlfluff.with({
            extra_args = { "--dialect", "postgres" },
        })

        local u = require("null-ls.utils")

        local diagnostics = vim.g.diagnostic

        local formatters = vim.g.formatters

        local sources = {}

        for _, diag in ipairs(diagnostics) do
            if type(diag) ~= "table" then
                diag = {
                    name = diag,
                    with = {
                        condition = exist_exec(diag),
                        method = nullls.methods.DIAGNOSTICS_ON_SAVE,
                    },
                }
            end
            table.insert(sources, nullls.builtins.diagnostics[diag.name].with(diag.with))
        end

        for _, fmt in ipairs(formatters) do
            if type(fmt) ~= "table" then
                fmt = {
                    name = fmt,
                    with = {
                        condition = exist_exec(fmt),
                    },
                }
            end
            table.insert(sources, nullls.builtins.formatting[fmt.name].with(fmt.with))
        end

        table.insert(sources, nullls.builtins.code_actions.gitsigns)
        table.insert(sources, nullls.builtins.code_actions.ts_node_action)
        table.insert(sources, nullls.builtins.code_actions.refactoring)
        table.insert(sources, nullls.builtins.code_actions.ltrs)

        nullls.setup({
            log_level = "error",
            sources = sources,
            temp_dir = "/tmp",
            update_in_insert = false,
            on_attach = require("lsp").on_attach,
            root_dir = u.root_pattern(unpack(vim.g.root_pattern)),
            should_attach = function(bufnr)
                -- if vim.g.disable_lsp then
                --     return false
                -- end

                return not require("float-preview").is_float(bufnr, vim.fn.bufname(bufnr))
            end,
        })
    end,
}
