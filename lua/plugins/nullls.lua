local present, nullls = pcall(require, "null-ls")
if not present then
    return
end

local u = require("null-ls.utils")

local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS_ON_SAVE

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
end

M.enable_python = function(opts)
    opts = opts or {
        linter = "flake8",
        mypy = false,
        bandit = false,
    }

    local sources = {}
    if opts.mypy then
        table.insert(
            sources,
            nullls.builtins.diagnostics.mypy.with({
                method = DIAGNOSTICS,
                env = {
                    PYTHONPATH = vim.env.PYTHONPATH,
                },
            })
        )
    end

    if opts.bandit then
        table.insert(
            sources,
            nullls.builtins.diagnostics.bandit.with({
                method = DIAGNOSTICS,
                env = {
                    PYTHONPATH = vim.env.PYTHONPATH,
                },
            })
        )
    end

    table.insert(
        sources,
        nullls.builtins.diagnostics[opts.linter].with({
            method = DIAGNOSTICS,
            env = {
                PYTHONPATH = vim.env.PYTHONPATH,
            },
        })
    )

    nullls.setup({ sources = sources, root_dir = u.root_pattern(".lvimrc", "Makefile", ".git") })
end

return M
