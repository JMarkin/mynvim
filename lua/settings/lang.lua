local g = vim.g
local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local lspconfig_util = require("lspconfig.util")

local M = {}

local on_attach = function(client, bufnr)
    require("lsp_signature").on_attach()
end

local function setup_lsp(lsp_name, opts)
    local lsp_installer = require("nvim-lsp-installer")
    local ok, _ = lsp_installer.get_server(lsp_name)
    if not ok then
        print("not found " .. lsp_name)
        return
    end
    local present, coq = pcall(require, "coq")
    if not present then
        print("not found coq_nvim")
        return
    end

    opts = coq.lsp_ensure_capabilities(opts)
    opts.on_attach = on_attach
    lspconfig[lsp_name].setup(opts)
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
                    globals = { "vim", "nnoremap", "require", "map", "vmap", "nmap", "tnoremap" },
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
            },
        },
    }

    local lsp_installer = require("nvim-lsp-installer")
    local ok, server = lsp_installer.get_server("rust_analyzer")
    if not ok then
        print("not found rust_analyzer")
        return
    end
    local _, coq = pcall(require, "coq")
    if not present then
        print("not found coq_nvim")
        return
    end
    vim.tbl_deep_extend("force", server:get_default_options(), opts)

    opts = coq.lsp_ensure_capabilities(opts)

    local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.6.10/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    rust_tools.setup({
        server = opts,
        dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
    })
    server:attach_buffers()
    rust_tools.start_standalone_if_required()
end

M.volar = function()
    --- https://github.com/johnsoncodehk/volar/discussions/606
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
            filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know)
            --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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

    lspconfig_configs.volar_doc = {
        default_config = {
            cmd = volar_cmd,
            root_dir = volar_root_dir,
            on_new_config = on_new_config,

            filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know):
            --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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

    lspconfig_configs.volar_html = {
        default_config = {
            cmd = volar_cmd,
            root_dir = volar_root_dir,
            on_new_config = on_new_config,

            filetypes = { "vue" },
            -- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
            --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
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
    setup_lsp("volar", {})
end

M.config = function()
    local servers = {
        "ccls",
        "cmake",
        "cssls",
        "dockerls",
        "graphql",
        "html",
        "jsonls",
        "pylsp",
        "rust_analyzer",
        "sqls",
        "sumneko_lua",
        "tsserver",
        "vimls",
        "volar",
        "yamlls",
    }

    require("nvim-lsp-installer").setup({
        automatic_installation = true,
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗",
            },
        },
    })

    local opts = {}

    for _, lsp in pairs(servers) do
        local s_lsp = M[lsp]
        if s_lsp == nil or s_lsp == "" then
            setup_lsp(lsp, opts)
        else
            s_lsp()
        end
    end
end

return M
