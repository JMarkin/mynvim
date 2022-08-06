local g = vim.g
local lspconfig = require("lspconfig")

local M = {}

local on_attach = function(_, bufnr)
    require("lsp_signature").on_attach({
        floating_window = true,
        hint_enable = false,
        transparency = 20,
        toggle_key = "<C-s>",
        select_signature_key = "<C-e>",
    })
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
capabilities.textDocument.completion = {
    completionItem = {
        insertReplaceSupport = true,
        preselectSupport = true,
        snippetSupport = true,
    },
}
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function setup_lsp(lsp_name, opts)
    local present, _ = pcall(require, "coq")
    if not present then
        print("not found coq_nvim")
        return
    end

    opts.capabilities = capabilities
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
                        enabled = true,
                    },
                    mypy = {
                        enabled = false,
                    },
                    isort = {
                        enabled = true,
                    },
                },
            },
        },
    }
    setup_lsp("pylsp", opts)
end

M.jedi_language_server = function()
    g.pydocstring_formatter = "google"
    g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }

    g.pydocstring_doq_path = "~/.pyenv/shims/doq"

    setup_lsp("jedi_language_server", {})
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
                    globals = { "vim", "nnoremap", "require", "map", "vmap", "nmap", "tnoremap", "xnoremap" },
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
        standalone = true,
    }

    local _, coq = pcall(require, "coq")
    if not present then
        print("not found coq_nvim")
        return
    end
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
end

M.volar = function()
    setup_lsp("volar", {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    })
end

M.clangd = function()
    require("clangd_extensions").setup()
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

local is_load = 0

M.config = function()
    if is_load == 1 then
        return
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
    is_load = 1
end

return M
