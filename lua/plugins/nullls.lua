local M = {}

local is_not_mini = require("custom.funcs").is_not_mini
local float_preview = require("custom.floatpreview")

M.plugin = {
    "jose-elias-alvarez/null-ls.nvim",
    cond = is_not_mini,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "CKolkey/ts-node-action",
            dependencies = { "nvim-treesitter" },
            opts = {},
        },
    },
    lazy = true,
    config = function()
        local nullls = require("null-ls")

        local methods = require("null-ls.methods")
        local DIAGNOSTICS = methods.internal.DIAGNOSTICS_ON_SAVE
        local FORMATTING = methods.internal.FORMATTING
        local RANGE_FORMATTING = methods.internal.RANGE_FORMATTING

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

        local h = require("null-ls.helpers")

        local bandit = h.make_builtin({
            name = "bandit",
            meta = {
                url = "https://github.com/PyCQA/bandit",
                description = [[Bandit is a tool designed to find common security issues in Python code. To do this Bandit
            processes each file, builds an AST from it, and runs appropriate plugins against the AST nodes. Once Bandit
            has finished scanning all the files it generates a report.]],
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
    end,
    cmd = { "NullLsEnableDefault", "NullLsInstallDefault" },
}

vim.api.nvim_create_user_command("NullLsEnableDefault", function(_)
    M.enable(nil, nil, nil)
end, {})

local DEFAULT_DIAGNOSTICS = {
    "ruff",
    "protolint",
    "curlylint",
    "sqlfluff",
}
local DEFAULT_FORMATTERS = {
    "sqlfluff",
    "ruff",
    "black",
    "yamlfmt",
    "protolint",
    "stylua",
    "djhtml",
    "isort",
    "nginx_beautifier",
    "taplo",
    "fixjson",
}

local DEFAULT_COMPLETIONS = {}

local DEFAULT_INSTALL_EXEC = {
    ruff = { command = "pip", args = { "install", "ruff" } },
    protolint = { command = "go", args = { "install", "github.com/yoheimuta/protolint/cmd/protolint@latest" } },
    curlylint = { command = "pip", args = { "install", "curlylint" } },
    spectral = { command = "npm", args = { "install", "-g", "@stoplight/spectral-cli" } },
    sqlfluff = { command = "pip", args = { "install", "sqlfluff" } },
    rome = { command = "npm", args = { "install", "-g", "rome" } },
    yapf = { command = "pip", args = { "install", "yapf" } },
    black = { command = "pip", args = { "install", "black" } },
    isort = { command = "pip", args = { "install", "isort" } },
    mypy = { command = "pip", args = { "install", "mypy" } },
    pylint = { command = "pip", args = { "install", "pylint" } },
    flake8 = { command = "pip", args = { "install", "flake8" } },
    docformatter = { command = "pip", args = { "install", "docformatter" } },
    yamlfmt = { command = "go", args = { "install", "github.com/google/yamlfmt/cmd/yamlfmt@latest" } },
    stylua = { command = "cargo", args = { "install", "stylua" } },
    djhtml = { command = "pip", args = { "install", "djhtml" } },
    fixjson = { command = "npm", args = { "install", "-g", "fixjson" } },
    nginxbeautifier = { command = "npm", args = { "install", "-g", "nginxbeautifier" } },
    taplo = { command = "cargo", args = { "install", "taplo-cli", "--locked" } },
    prettierd = { command = "npm", args = { "install", "-g", "@fsouza/prettierd" } },
}
local EXEC_CONVERT = {
    ["nginx_beautifier"] = "nginxbeautifier",
}

local function exec_install(exec)
    exec = EXEC_CONVERT[exec] or exec
    local function condition(_)
        if vim.fn.executable(exec) ~= 1 then
            local shell = DEFAULT_INSTALL_EXEC[exec]
            if shell ~= nil then
                shell = vim.fn.map(shell, function(_, v)
                    return v
                end)
                shell.on_exit = function(j, return_val)
                    if return_val ~= 0 then
                        vim.notify(exec .. " error" .. " " .. j:result(), vim.log.levels.WARN)
                    end
                end
                local job = require("plenary.job"):new(shell)
                vim.notify(exec .. " not found, try install", vim.log.levels.INFO)
                job:start()
                return true
            end
            vim.notify(exec .. " not found, please install", vim.log.levels.WARN)
            return false
        end
        return true
    end
    return condition
end

local function exist_exec(exec)
    exec = EXEC_CONVERT[exec] or exec
    local function condition(_)
        return vim.fn.executable(exec) == 1
    end
    return condition
end

M.install_default = function()
    local diagnostics = DEFAULT_DIAGNOSTICS
    local formatters = DEFAULT_FORMATTERS
    local completions = DEFAULT_COMPLETIONS
    local sources = {}
    vim.list_extend(sources, diagnostics)
    vim.list_extend(sources, formatters)
    vim.list_extend(sources, completions)
    for _, source in ipairs(sources) do
        vim.notify("try to install " .. source, vim.log.levels.DEBUG)
        local installed = exec_install(source)(nil)
        if installed then
            vim.notify("installed " .. source, vim.log.levels.DEBUG)
        end
    end
end

-- local enabled = false

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
M.enable = function(diagnostics, formatters, completions)
    -- if enabled then
    --     return
    -- end
    -- print(string.format("%s %s %s", #diagnostics, #formatters, #completions))
    -- enabled = true
    local u = require("null-ls.utils")

    local nullls = require("null-ls")

    diagnostics = diagnostics or DEFAULT_DIAGNOSTICS

    formatters = formatters or DEFAULT_FORMATTERS

    completions = completions or DEFAULT_COMPLETIONS

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

    for _, cmp in ipairs(completions) do
        if type(cmp) ~= "table" then
            cmp = {
                name = cmp,
                with = {},
            }
        end
        table.insert(sources, nullls.builtins.completion[cmp.name].with(cmp.with))
    end

    table.insert(sources, nullls.builtins.code_actions.gitsigns)
    table.insert(sources, nullls.builtins.code_actions.ts_node_action)
    table.insert(sources, nullls.builtins.code_actions.refactoring)

    nullls.setup({
        log_level = "error",
        sources = sources,
        temp_dir = "/tmp",
        update_in_insert = false,
        on_attach = require("settings.lang").on_attach,
        root_dir = u.root_pattern(unpack(vim.g.root_pattern)),
        should_attach = function(bufnr)
            return bufnr ~= float_preview.buf
        end,
    })
end

return M
