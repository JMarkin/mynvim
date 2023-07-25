local utils = require("lsp.utils")
local external_install = require("custom.external_install")

return {
    install = function()
        if vim.fn.executable("clangd") ~= 1 then
            print("please manual install clangd")
            print("alpine: sudo apk add clang-extra-tools llvm16")
        end
    end,
    setup = function()
        local opts = {}
        opts.capabilities = utils.capabilities
        opts.on_attach = utils.on_attach

        require("clangd_extensions").setup({
            server = opts,
            extensions = {
                autoSetHints = false,
                inlay_hints = {
                    inline = false,
                },
            },
        })
    end,
}
