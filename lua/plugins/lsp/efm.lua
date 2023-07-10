local M = {}

M.plugin = {
    "JMarkin/efmls-configs-nvim",
    requires = { "neovim/nvim-lspconfig" },
    build = "go install github.com/mattn/efm-langserver@latest",
    config = function ()

    end
}

return M
