-- Maeson cool but

local function pip_install(name, pip_args)
    return {
        command = "bash",
        args = { "pip.sh", name, pip_args },
        cwd = "~/.config/nvim/installers",
    }
end

local DEFAULT_INSTALL_EXEC = {
    -- pip
    ruff = pip_install("ruff", "ruff"),
    ["ruff-lsp"] = pip_install("ruff-lsp", "ruff-lsp"),
    curlylint = pip_install("curlylint", "curlylint" ),
    sqlfluff = pip_install("sqlfluff", "sqlfluff"),
    sqlfmt = pip_install("sqlfmt", "shandy-sqlfmt[jinjafmt]"),
    yapf = pip_install("yapf", "yapf"),
    black = pip_install("black", "black"),
    isort = pip_install("isort", "isort"),
    mypy = pip_install("mypy", "mypy"),
    pylint = pip_install("pylint", "pylint"),
    flake8 = pip_install("flake8", "flake8"),
    djhtml = pip_install("djhtml", "djhtml"),
    docformatter = pip_install("docformatter", "docformatter"),
    ["jedi-language-server"] = pip_install("jedi-language-server", "git+https://github.com/JMarkin/jedi-language-server.git"),
    ["python-lsp-server"] = pip_install("python-lsp-server", "python-lsp-server"),
    pyright = pip_install("pyright", "pyright"),
    ["nginx-language-server"] = pip_install("nginx-language-server", "nginx-language-server"),
    djlint = pip_install("djlint", "djlint"),

    -- npm
    spectral = { command = "npm", args = { "install", "-g", "@stoplight/spectral-cli" } },
    rome = { command = "npm", args = { "install", "-g", "rome" } },
    fixjson = { command = "npm", args = { "install", "-g", "fixjson" } },
    nginxbeautifier = { command = "npm", args = { "install", "-g", "nginxbeautifier" } },
    prettierd = { command = "npm", args = { "install", "-g", "@fsouza/prettierd" } },
    prettier = { command = "npm", args = { "install", "-g", "prettier" } },
    biome = { command = "npm", args = { "install", "-g", "@biomejs/biome" } },
    ["bash-language-server"] = { command = "npm", args = { "install", "-g", "bash-language-server" } },
    ["vue-language-server"] = { command = "npm", args = { "install", "-g", "@volar/vue-language-server" } },
    ["docker-compose-langserver"] = {
        command = "npm",
        args = { "install", "-g", "@microsoft/compose-language-service" },
    },
    ["docker-langserver"] = { command = "npm", args = { "install", "-g", "dockerfile-language-server-nodejs" } },
    ["yaml-language-server"] = { command = "npm", args = { "install", "-g", "yaml-language-server" } },
    ["vscode-json-language-server"] = { command = "npm", args = { "install", "-g", "vscode-langservers-extracted" } },
    ["vscode-html-language-server"] = { command = "npm", args = { "install", "-g", "vscode-langservers-extracted" } },
    ["vscode-css-language-server"] = { command = "npm", args = { "install", "-g", "vscode-langservers-extracted" } },
    ["vim-language-server"] = { command = "npm", args = { "install", "-g", "vim-language-server" } },
    ["typescript-language-server"] = {
        command = "npm",
        args = { "install", "-g", "typescript", "typescript-language-server" },
    },

    -- go
    protolint = { command = "go", args = { "install", "github.com/yoheimuta/protolint/cmd/protolint@latest" } },
    yamlfmt = { command = "go", args = { "install", "github.com/google/yamlfmt/cmd/yamlfmt@latest" } },

    -- cargo
    ["nil"] = {
        command = "cargo",
        args = { "install", "--git", "https://github.com/oxalica/nil.git", "--tag", "2023-08-09", "nil" },
    },
    stylua = {
        command = "cargo",
        args = { "install", "--locked", "--git", "https://github.com/JohnnyMorganz/StyLua.git", "--tag", "v0.20.0" },
    },
    taplo = {
        command = "cargo",
        args = {
            "install",
            "--locked",
            "--features",
            "lsp",
            "--git",
            "https://github.com/tamasfe/taplo.git",
            "taplo-cli",
        },
    },
    neocmakelsp = {
        command = "cargo",
        args = {
            "install",
            "neocmakelsp",
        },
    },
    ['jinja-lsp'] = {
        command = "cargo",
        args = {
            "install",
            "jinja-lsp",
        },
    },

    -- rustup
    ["rust-analyzer"] = {
        command = "rustup",
        args = { "component", "add", "rust-analyzer" },
    },
    ["rustfmt"] = {
        command = "rustup",
        args = { "component", "add", "rustfmt" },
    },

    -- custom
    ["lua-language-server"] = {
        command = "bash",
        args = { "luals.sh" },
        cwd = "~/.config/nvim/installers",
    },
}

local function external_install(exec, sync, update)
    local f = function()
        local notify = nil
        if vim.fn.executable(exec) ~= 1 or update then
            local shell = DEFAULT_INSTALL_EXEC[exec]
            if shell ~= nil then
                shell = vim.fn.map(shell, function(_, v)
                    return v
                end)
                shell.enable_recording = false
                shell.on_exit = function(_, return_val)
                    if return_val ~= 0 then
                        notify = vim.notify(string.format("%s error", exec), vim.log.levels.WARN, { replace = notify })
                    else
                        notify = vim.notify(
                            string.format("Complete install %s", exec),
                            vim.log.levels.INFO,
                            { replace = notify }
                        )
                    end
                end
                shell.on_stdout = function(_, data)
                    notify = vim.notify(
                        string.format("INSTALL %s %s", exec, data),
                        vim.log.levels.INFO,
                        { replace = notify }
                    )
                end
                shell.on_stderr = function(_, data)
                    notify = vim.notify(
                        string.format("INSTALL %s %s", exec, data),
                        vim.log.levels.INFO,
                        { replace = notify }
                    )
                end
                local job = require("plenary.job"):new(shell)
                notify = vim.notify(exec .. " not found, try install", vim.log.levels.INFO)
                job:start()
                if sync then
                    -- 10min
                    job:wait(1000 * 60 * 10, 5, true)
                end
            else
                vim.notify(exec .. " not found config, please install manually", vim.log.levels.WARN)
            end
        else
            vim.notify(string.format("%s installed", exec), vim.log.levels.INFO)
        end
    end
    if sync then
        f()
    else
        vim.schedule(f)
    end
end

local default_sources = {
    "ruff",
    "mypy",
    "stylua",
    "nginxbeautifier",
    "biome",
    "prettier",
    "fixjson",
    "rustfmt",
    "taplo",
    "sqlfmt",
    "djlint",
}

local install = function(sync, update, sources)
    if not sources then
        sources = default_sources
    end
    for _, source in ipairs(sources) do
        external_install(source, sync, update)
    end

end

vim.api.nvim_create_user_command("ExternalInstallDefault", function(_)
    install()
end, {})

vim.api.nvim_create_user_command("ExternalInstallDefaultSync", function(_)
    install(true)
end, {})

vim.api.nvim_create_user_command("ExternalUpdateDefault", function(_)
    install(false, true)
end, {})

vim.api.nvim_create_user_command("ExternalUpdateDefaultSync", function(_)
    install(true, true)
end, {})

return external_install
