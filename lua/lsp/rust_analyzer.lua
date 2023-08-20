local utils = require("lsp.utils")
local external_install = require("custom.external_install")

return {
    install = function(sync)
        external_install("rust-analyzer", sync)
    end,
    setup = function()
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

        opts.capabilities = utils.capabilities
        opts.on_attach = utils.on_attach

        local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.6.10/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        rust_tools.setup({
            tools = {
                inlay_hints = {
                    auto = false,
                },
            },
            server = opts,
            dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        })
    end,
}
