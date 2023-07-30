if vim.env.NVIM_MINI ~= nil then
    return {}
end

local default_lsp = function(bin_name, lsp_name, opts)
    if not opts then
        opts = {}
    end
    local utils = require("lsp.utils")
    local external_install = require("custom.external_install")

    return {
        install = function(sync)
            external_install(bin_name, sync)
        end,
        setup = function()
            utils.setup_lsp(lsp_name, opts)
        end,
    }
end

local M = {}
M.lsps = {
    lua_ls = require("lsp.lua_ls"),
    rust_analyzer = require("lsp.rust_analyzer"),
    bashls = default_lsp("bash-language-server", "bashls"),
    vimls = default_lsp("vim-language-server", "vimls"),
    html = default_lsp("vscode-html-language-server", "html", {
        filetypes = { "html", "htmldjango" },
    }),
    cssls = default_lsp("vscode-css-language-server", "cssls"),
    jedi_language_server = default_lsp("jedi-language-server", "jedi_language_server", {
        filetypes = { "python", "python.django", "django" },
    }),
    taplo = default_lsp("taplo", "taplo"),
    neocmakelsp = default_lsp("neocmakelsp", "neocmake"),
    clangd = require("lsp.clangd"),
    volar = require("lsp.volar"),
    docker_compose_language_service = default_lsp("docker-compose-langserver", "docker_compose_language_service"),
    dockerls = default_lsp("docker-langserver", "dockerls"),
    yamlls = default_lsp("yaml-language-server", "yamlls", {
        settings = {
            yaml = {
                schemaStore = {
                    enable = false,
                },
                schemas = require("schemastore").yaml.schemas(),
            },
            redhat = {
                telemetry = {
                    enabled = false,
                },
            },
        },
    }),
    jsonls = default_lsp("vscode-json-language-server", "jsonls", {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    }),
}
M.install = function(sync)
    for _, lsp in pairs(M.lsps) do
        lsp.install(sync)
    end
end

M.setup = function()
    for _, lsp in pairs(M.lsps) do
        lsp.setup()
    end
end

return M