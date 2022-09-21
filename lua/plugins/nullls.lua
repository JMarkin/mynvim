local present, nullls = pcall(require, "null-ls")
if not present then
    return
end

local u = require("null-ls.utils")

local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS_ON_SAVE
local FORMATTING = methods.internal.FORMATTING
local RANGE_FORMATTING = methods.internal.RANGE_FORMATTING

local M = {}

M.config = function()
    local h = require("null-ls.helpers")

    local bandit = h.make_builtin({
        name = "bandit",
        meta = {
            url = "https://github.com/PyCQA/bandit",
            description = "Bandit is a tool designed to find common security issues in Python code. To do this Bandit processes each file, builds an AST from it, and runs appropriate plugins against the AST nodes. Once Bandit has finished scanning all the files it generates a report.",
        },
        method = DIAGNOSTICS,
        filetypes = { "python" },
        generator_opts = {
            command = "bandit",
            to_stdin = false,
            args = {
                "-q",
                "--msg-template",
                "|{line}| |{col}| |{test_id}| |{severity}| |{msg}|",
                "-f",
                "custom",
                "--exit-zero",
                "$FILENAME",
            },
            format = "line",
            check_exit_code = function(code)
                return code == 0
            end,
            on_output = h.diagnostics.from_pattern(
                "|(.*)| |(.*)| |(.*)| |(.*)| |(.*)|",
                { "row", "col", "code", "severity", "message" },
                {
                    severities = {
                        UNDEFINED = h.diagnostics.severities["hint"],
                        LOW = h.diagnostics.severities["information"],
                        MEDIUM = h.diagnostics.severities["warning"],
                        HIGH = h.diagnostics.severities["error"],
                    },
                }
            ),
        },
        factory = h.generator_factory,
    })

    rawset(nullls.builtins.diagnostics, "bandit", bandit)

    local docformatter = h.make_builtin({
        name = "docformatter",
        meta = {
            url = "https://github.com/PyCQA/docformatter",
            description = "Formats docstrings to follow PEP 257",
        },
        method = { FORMATTING, RANGE_FORMATTING },
        filetypes = { "python" },
        generator_opts = {
            command = "docformatter",
            args = h.range_formatting_args_factory({
                "-",
            }, "--range", nil, { use_rows = true }),
            to_stdin = true,
        },
        factory = h.formatter_factory,
    })
    rawset(nullls.builtins.formatting, "docformatter", docformatter)
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
M.enable = function(diagnostics, formatters)
    diagnostics = diagnostics or {
        "flake8",
        "djlint",
        "protolint",
    }

    formatters = formatters or {
        "isort",
        "yapf",
        "stylua",
        "protolint",
    }

    local sources = {}

    for _, diag in ipairs(diagnostics) do
        if diag == "djlint" then
            table.insert(
                sources,
                nullls.builtins.diagnostics[diag].with({
                    method = DIAGNOSTICS,
                    filetypes = { "jinja.html", "htmldjango" },
                    env = {
                        PYTHONPATH = vim.env.PYTHONPATH,
                    },
                })
            )
        else
            table.insert(
                sources,
                nullls.builtins.diagnostics[diag].with({
                    method = DIAGNOSTICS,
                    env = {
                        PYTHONPATH = vim.env.PYTHONPATH,
                    },
                })
            )
        end
    end

    for _, fmt in ipairs(formatters) do
        if fmt == "djlint" then
            table.insert(
                sources,
                nullls.builtins.formatting[fmt].with({
                    filetypes = { "jinja.html", "htmldjango" },
                    env = {
                        PYTHONPATH = vim.env.PYTHONPATH,
                    },
                })
            )
        else
            table.insert(
                sources,
                nullls.builtins.formatting[fmt].with({
                    env = {
                        PYTHONPATH = vim.env.PYTHONPATH,
                    },
                })
            )
        end
    end

    nullls.setup({ sources = sources, root_dir = u.root_pattern(".lvimrc", "Makefile", ".git") })
end

return M
