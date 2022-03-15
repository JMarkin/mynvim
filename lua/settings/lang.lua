local cmd = vim.cmd
local g = vim.g

local M = {}

local Job = require("plenary.job")

function setup_lsp(lsp_name, opts)
    local lsp_installer = require("nvim-lsp-installer")
    local ok, server = lsp_installer.get_server(lsp_name)
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
    server:setup(opts)
end

M.python = function()
    g.pydocstring_formatter = "google"
    g.neoformat_enabled_python = { "yapf", "isort", "docformatter" }
    g.neomake_python_enabled_makers = { "python", "flake8" }

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
                },
            },
        },
    }
    setup_lsp("pylsp", opts)
end

M.lua = function()
    local opts = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = "/usr/bin/luajit",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim", "nnoremap" },
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

M.rust = function()
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
    local present, coq = pcall(require, "coq")
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

M.maps = function(m)
    nnoremap("<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", "GoTo: definition")
    nnoremap("<leader>D", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", "GoTo: definition")
    nnoremap("<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", "GoTo: implementation")
    nnoremap("<leader>r", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "GoTo: references")

    nnoremap("<leader>ld", ":lua require('neogen').generate()<CR>", "Lang: generete docs")
    nnoremap("<leader>li", "<cmd>lua vim.diagnostic.open_float()<CR>", "Lang: diagnostic float")
    nnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", "Lang: code action")
    nnoremap("<leader>la", "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>", "Lang: code action")
    nnoremap("<leader>lr", "<cmd>lua require('lspsaga.rename').rename()<CR>", "Lang: rename")
    nnoremap("<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", "Lang: hover")
    nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", "Lang: lsp format")
end

return M
