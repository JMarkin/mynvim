local utils = require("lsp.utils")
local external_install = require("custom.external_install")

local M = {
    install = function(sync)
        external_install("lua-language-server", sync)
    end,
    setup = function()
        local opts = {
            settings = {
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                    hint = {
                        enable = true,
                    },
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of
                        -- Neovim)
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {
                            "vim",
                        },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME")] = true,
                            [vim.fn.expand("~/.config/nvim/lua")] = true,
                        },
                    },
                },
            },
        }
        utils.setup_lsp("lua_ls", opts)
    end,
}

return M
