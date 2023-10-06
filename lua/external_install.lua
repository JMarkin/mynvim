local DEFAULT_INSTALL_EXEC = {
    -- pip
    ruff = { command = "pip", args = { "install", "-U", "ruff" } },
    curlylint = { command = "pip", args = { "install", "-U", "curlylint" } },
    sqlfluff = { command = "pip", args = { "install", "-U", "sqlfluff" } },
    yapf = { command = "pip", args = { "install", "-U", "yapf" } },
    black = { command = "pip", args = { "install", "-U", "black" } },
    isort = { command = "pip", args = { "install", "-U", "isort" } },
    mypy = { command = "pip", args = { "install", "-U", "mypy" } },
    pylint = { command = "pip", args = { "install", "-U", "pylint" } },
    flake8 = { command = "pip", args = { "install", "-U", "flake8" } },
    djhtml = { command = "pip", args = { "install", "-U", "djhtml" } },
    docformatter = { command = "pip", args = { "install", "-U", "docformatter" } },
    jedi_language_server = { command = "pip", args = { "install", "-U", "jedi_language_server==0.39.0" } },
    ["jedi-language-server"] = { command = "pip", args = { "install", "-U", "jedi_language_server==0.39.0" } },
    pyright = { command = "pip", args = { "install", "-U", "pyright" } },

    -- npm
    spectral = { command = "npm", args = { "install", "-g", "@stoplight/spectral-cli" } },
    rome = { command = "npm", args = { "install", "-g", "rome" } },
    fixjson = { command = "npm", args = { "install", "-g", "fixjson" } },
    nginxbeautifier = { command = "npm", args = { "install", "-g", "nginxbeautifier" } },
    prettierd = { command = "npm", args = { "install", "-g", "@fsouza/prettierd" } },
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
        args = { "install", "--locked", "--git", "https://github.com/JohnnyMorganz/StyLua.git", "--tag", "v0.18.1" },
    },
    taplo = {
        command = "cargo",
        args = {
            "install",
            "--locked",
            "--features",
            "lsp",
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

    -- rustup
    ["rust-analyzer"] = {
        command = "rustup",
        args = { "component", "add", "rust-analyzer" },
    },

    -- custom
    ["lua-language-server"] = {
        command = "bash",
        args = { "luals.sh" },
        cwd = "~/.config/nvim/installers",
    },
}

local function external_install(exec, sync)
    local f = function()
        local notify = nil
        if vim.fn.executable(exec) ~= 1 then
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

local install = function(sync)
    local sources = {
        "ruff",
        "black",
        "stylua",
        "nginxbeautifier",
        "prettier",
        "mypy",
        "isort",
        "flake8",
        "fixjson",
    }
    for _, source in ipairs(sources) do
        external_install(source, sync)
    end
end

vim.api.nvim_create_user_command("ExternalInstallDefault", function(_)
    install()
end, {})

vim.api.nvim_create_user_command("ExternalInstallDefaultSync", function(_)
    install(true)
end, {})

return external_install
