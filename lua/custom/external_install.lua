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

    -- npm
    spectral = { command = "npm", args = { "install", "-g", "@stoplight/spectral-cli" } },
    rome = { command = "npm", args = { "install", "-g", "rome" } },
    fixjson = { command = "npm", args = { "install", "-g", "fixjson" } },
    nginxbeautifier = { command = "npm", args = { "install", "-g", "nginxbeautifier" } },
    prettierd = { command = "npm", args = { "install", "-g", "@fsouza/prettierd" } },
    ["bash-language-server"] = { command = "npm", args = { "install", "-g", "bash-language-server" } },
    ["vue-language-server"] = { command = "npm", args = { "install", "-g", "@volar/vue-language-server" } },

    -- go
    protolint = { command = "go", args = { "install", "github.com/yoheimuta/protolint/cmd/protolint@latest" } },
    yamlfmt = { command = "go", args = { "install", "github.com/google/yamlfmt/cmd/yamlfmt@latest" } },

    -- cargo
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

local function exec_install(exec)
    vim.schedule(function()
        if vim.fn.executable(exec) ~= 1 then
            local shell = DEFAULT_INSTALL_EXEC[exec]
            if shell ~= nil then
                shell = vim.fn.map(shell, function(_, v)
                    return v
                end)
                shell.on_exit = function(_, return_val)
                    if return_val ~= 0 then
                        vim.notify(string.format("%s error", exec), vim.log.levels.WARN)
                        return
                    else
                        vim.notify(string.format("Complete install %s", exec), vim.log.levels.INFO)
                    end
                end
                shell.on_stdout = function(_, data)
                    vim.notify(string.format("INSTALL %s ", exec) .. data, vim.log.levels.DEBUG)
                end
                shell.on_stderr = function(_, data)
                    vim.notify(string.format("INSTALL %s ", exec) .. data, vim.log.levels.DEBUG)
                end
                local job = require("plenary.job"):new(shell)
                vim.notify(exec .. " not found, try install", vim.log.levels.INFO)
                job:start()
            end
            vim.notify(exec .. " not found config, please install manually", vim.log.levels.WARN)
        end
    end)
end

return exec_install
