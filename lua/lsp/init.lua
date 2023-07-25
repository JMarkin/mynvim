if vim.env.NVIM_MINI ~= nil then
    return {}
end

return {
    lua_ls = require("lsp.lua_ls"),
    rust_analyzer = require("lsp.rust_analyzer"),
    bashls = require("lsp.bashls"),
    jedi_language_server = require("lsp.jedi_language_server"),
    taplo = require("lsp.taplo"),
    clangd = require("lsp.clangd"),
    volar = require("lsp.volar"),
}

-- M.jsonls = function()
--     setup_lsp("jsonls", {
--         settings = {
--             json = {
--                 schemas = require("schemastore").json.schemas(),
--                 validate = { enable = true },
--             },
--         },
--     })
-- end
--
-- M.yamlls = function()
--     setup_lsp("yamlls", {
--         settings = {
--             yaml = {
--                 schemaStore = {
--                     -- You must disable built-in schemaStore support if you want to use
--                     -- this plugin and its advanced options like `ignore`.
--                     enable = false,
--                 },
--                 schemas = require("schemastore").yaml.schemas(),
--             },
--         },
--     })
-- end
--
-- M.html = function()
--     setup_lsp("html", {
--         filetypes = { "html", "htmldjango" },
--     })
-- end
