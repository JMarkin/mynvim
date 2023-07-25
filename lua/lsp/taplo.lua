local utils = require("lsp.utils")
local external_install = require("custom.external_install")

return {
    install = function()
        external_install("taplo")
    end,
    setup = function()
        utils.setup_lsp("taplo", {})
    end,
}
