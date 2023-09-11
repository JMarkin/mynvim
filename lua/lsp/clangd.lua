local utils = require("lsp.utils")
local external_install = require("external_install")

return {
    install = function(sync)
        if vim.fn.executable("clangd") ~= 1 then
            print("please manual install clangd")
            print("alpine: sudo apk add clang-extra-tools llvm16")
        end
    end,
    setup = function()
        local opts = {}
        opts.on_attach = function(...)
            local st = utils.on_attach(...)
            if st then
                require("clangd_extensions.inlay_hints").setup_autocmd()
                require("clangd_extensions.inlay_hints").set_inlay_hints()
            end
        end
        require("clangd_extensions").setup({
            inlay_hints = {
                inline = vim.fn.has("nvim-0.10") == 1,
            },
        })

        utils.setup_lsp("clangd", opts)
    end,
}
