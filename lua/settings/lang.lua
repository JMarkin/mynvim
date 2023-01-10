local g = vim.g

if vim.env.NVIM_MINI ~= nil then
    return {}
end

vim.g.navic_silence = true
local M = {}

local on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
capabilities.textDocument.completion = {
    completionItem = {
        insertReplaceSupport = true,
        preselectSupport = false,
        snippetSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    },
}

local function setup_lsp(lsp_name, opts)
    opts.capabilities = capabilities
    opts.on_attach = on_attach
    require("lspconfig")[lsp_name].setup(opts)
end

M.yamlls = function()
    local cfg = require("yaml-companion").setup({})
    setup_lsp("yamlls", cfg)
end

M.pylsp = function()
    g.pydocstring_formatter = "google"
    g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }

    g.pydocstring_doq_path = "~/.pyenv/shims/doq"

    local opts = {
        settings = {
            pylsp = {
                configurationSources = {},
                plugins = {
                    flake8 = {
                        enabled = false,
                    },
                    mccabe = {
                        enabled = false,
                    },
                    pycodestyle = {
                        enabled = false,
                    },
                    pydocstyle = {
                        enabled = false,
                    },
                    pyflakes = {
                        enabled = false,
                    },
                    pylint = {
                        enabled = false,
                    },
                    yapf = {
                        enabled = false,
                    },
                    mypy = {
                        enabled = false,
                    },
                    isort = {
                        enabled = false,
                    },
                },
            },
        },
    }
    setup_lsp("pylsp", opts)
end

M.jedi_language_server_is_load = 0
M.jedi_language_server = function()
    if M.jedi_language_server_is_load == 1 then
        return 1
    end
    g.pydocstring_formatter = "google"
    g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }

    g.pydocstring_doq_path = "~/.pyenv/shims/doq"

    setup_lsp("jedi_language_server", {
        filetypes = { "python", "python.django", "django" },
    })
    M.jedi_language_server_is_load = 1
end

M.sumneko_lua = function()
    local opts = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = vim.env.LUAJIT,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        "vim",
                        "nnoremap",
                        "require",
                        "map",
                        "vmap",
                        "nmap",
                        "tnoremap",
                        "xnoremap",
                        "inoremap",
                        "vnoremap",
                        "packer_plugins",
                    },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
            },
        },
    }
    setup_lsp("sumneko_lua", opts)
end

M.rust_analyzer = function()
    g.neoformat_enabled_rust = { "rustfmt" }
    g.neoformat_rust_rustfmt = {
        exe = "rustfmt",
        args = { "--edition", "2021" },
        stdin = 1,
    }

    local present, rust_tools = pcall(require, "rust-tools")
    if not present then
        print("not found rust_tools")
        return
    end

    local opts = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
                completion = {
                    autoimport = {
                        enable = false,
                    },
                },
                inlayHints = { locationLinks = false },
            },
        },
        standalone = true,
    }

    opts.capabilities = capabilities
    opts.on_attach = on_attach

    local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.6.10/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    rust_tools.setup({
        tools = {},
        server = opts,
        dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
    })
end

M.volar = function()
    local lspconfig_configs = require("lspconfig.configs")
    local lspconfig_util = require("lspconfig.util")
    local function on_new_config(new_config, new_root_dir)
        local function get_typescript_server_path(root_dir)
            local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
            return project_root
                    and (lspconfig_util.path.join(
                        project_root,
                        "node_modules",
                        "typescript",
                        "lib",
                        "tsserverlibrary.js"
                    ))
                or ""
        end

        if
            new_config.init_options
            and new_config.init_options.typescript
            and new_config.init_options.typescript.serverPath == ""
        then
            new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
        end
    end

    local volar_cmd = { "vue-language-server", "--stdio" }
    local volar_root_dir = lspconfig_util.root_pattern("package.json")

    lspconfig_configs.volar_api = {
        default_config = {
            cmd = volar_cmd,
            root_dir = volar_root_dir,
            on_new_config = on_new_config,
            -- filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know)
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
            init_options = {
                typescript = {
                    serverPath = "",
                },
                languageFeatures = {
                    implementation = true, -- new in @volar/vue-language-server v0.33
                    references = true,
                    definition = true,
                    typeDefinition = true,
                    callHierarchy = true,
                    hover = true,
                    rename = true,
                    renameFileRefactoring = true,
                    signatureHelp = true,
                    codeAction = true,
                    workspaceSymbol = true,
                    completion = {
                        defaultTagNameCase = "both",
                        defaultAttrNameCase = "kebabCase",
                        getDocumentNameCasesRequest = false,
                        getDocumentSelectionRequest = false,
                    },
                },
            },
        },
    }
    setup_lsp("volar_api", {})

    lspconfig_configs.volar_doc = {
        default_config = {
            cmd = volar_cmd,
            root_dir = volar_root_dir,
            on_new_config = on_new_config,

            -- filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know):
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
            init_options = {
                typescript = {
                    serverPath = "",
                },
                languageFeatures = {
                    implementation = true, -- new in @volar/vue-language-server v0.33
                    documentHighlight = true,
                    documentLink = true,
                    codeLens = { showReferencesNotification = true },
                    -- not supported - https://github.com/neovim/neovim/pull/15723
                    semanticTokens = false,
                    diagnostics = true,
                    schemaRequestService = true,
                },
            },
        },
    }
    setup_lsp("volar_doc", {})

    lspconfig_configs.volar_html = {
        default_config = {
            cmd = volar_cmd,
            root_dir = volar_root_dir,
            on_new_config = on_new_config,

            -- filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            init_options = {
                typescript = {
                    serverPath = "",
                },
                documentFeatures = {
                    selectionRange = true,
                    foldingRange = true,
                    linkedEditingRange = true,
                    documentSymbol = true,
                    -- not supported - https://github.com/neovim/neovim/pull/13654
                    documentColor = false,
                    documentFormatting = {
                        defaultPrintWidth = 100,
                    },
                },
            },
        },
    }
    setup_lsp("volar_html", {})
end

M.clangd = function()
    local opts = {}
    opts.capabilities = capabilities
    opts.on_attach = on_attach

    require("clangd_extensions").setup({
        server = opts,
    })
end

M.jsonls = function()
    require("lspconfig").jsonls.setup({
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
            },
        },
    })
end

M.html = function()
    setup_lsp("html", {
        filetypes = { "html", "htmldjango" },
    })
end

local is_load = 0

M.config = function()
    if is_load == 1 then
        return is_load
    end
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            local s_lsp = M[server_name]
            if s_lsp == nil or s_lsp == "" then
                vim.notify("default config for " .. server_name, vim.log.levels.DEBUG)
                setup_lsp(server_name, {})
            else
                s_lsp()
            end
        end,
    })

    if vim.fn.executable("jedi-language-server") == 1 then
        M.jedi_language_server()
    end

    vim.diagnostic.config({
        underline = true,
        signs = true,
        virtual_text = false,
        -- virtual_lines = { only_current_line = true },
        float = true,
        update_in_insert = false,
        severity_sort = true,
    })

    is_load = 1
    return is_load
end

return M
