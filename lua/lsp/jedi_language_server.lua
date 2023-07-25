local utils = require("lsp.utils")
local external_install = require("custom.external_install")

return {
    install = function()
        external_install("jedi-language-server")
    end,
    setup = function()
        utils.setup_lsp("jedi_language_server", {
            filetypes = { "python", "python.django", "django" },
        })
    end,
}
