local g = vim.g

local is_large_file = require("custom.largefiles").is_large_file
if vim.env.NVIM_MINI ~= nil then
    return {}
end

local M = {}

local diag_opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
    scope = "cursor",
}

local on_attach = function(client, bufnr)
    if is_large_file(bufnr, true) then
        local clients = vim.lsp.buf_get_clients(bufnr)
        for client_id, _ in pairs(clients) do
            vim.lsp.buf_detach_client(bufnr, client_id)
        end
        return
    end

    vim.bo.tagfunc = nil
end

M.on_attach = on_attach

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
    local check_buf_is_float = require("float-preview").is_float

    opts.capabilities = capabilities
    opts.on_attach = on_attach
    local lsp = require("lspconfig")
    local conf = lsp[lsp_name]
    if vim.g.disable_lsp then
        opts.autostart = false
    end
    conf.setup(opts)

    local try_add = conf.manager.try_add
    conf.manager.try_add = function(bufnr, project_root)
        if check_buf_is_float(bufnr) then
            return
        end
        if check_buf_is_float(bufnr, vim.fn.bufname(bufnr)) then
            return
        end

        if is_large_file(bufnr, true) then
            vim.notify("disable lsp large buffer", vim.log.levels.DEBUG)
            return
        end

        return try_add(bufnr, project_root)
    end
end

M.setup_lsp = setup_lsp

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

M.jedi_language_server = function()
    setup_lsp("jedi_language_server", {
        filetypes = { "python", "python.django", "django" },
    })
end

M.lua_ls = function()
    local opts = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of
                    -- Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = vim.env.LUAJIT,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        "vim",
                        "require",
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
    setup_lsp("lua_ls", opts)
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
    setup_lsp("jsonls", {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
            },
        },
    })
end

M.yamlls = function()
    setup_lsp("yamlls", {
        settings = {
            yaml = {
                schemaStore = {
                    -- You must disable built-in schemaStore support if you want to use
                    -- this plugin and its advanced options like `ignore`.
                    enable = false,
                },
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    })
end

M.html = function()
    setup_lsp("html", {
        filetypes = { "html", "htmldjango" },
    })
end

return M
