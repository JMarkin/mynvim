local utils = require("lsp.utils")
local external_install = require("external_install")

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
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = {
                            "vim",
                        },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIM/lazy")] = true,
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
