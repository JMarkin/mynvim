local utils = require("lsp.utils")
local external_install = require("external_install")

return {
    install = function(sync, update)
        external_install("rust-analyzer", sync, update)
    end,
    setup = function()
        vim.g.rustaceanvim = {
            tools = {},
            server = {
                on_attach = utils.on_attach,
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
            },
        }
    end,
}
