local is_large_file = require("custom.largefiles").is_large_file

local M = {}

local diag_opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
    scope = "cursor",
}

local on_attach = function(client, bufnr)
    -- vim.print(client.server_capabilities)

    if is_large_file(bufnr, true) then
        vim.lsp.buf_detach_client(bufnr, client.id)
        return
    end

    local inlayhint = client.server_capabilities.inlayHintProvider
    if inlayhint then
        vim.keymap.set({ "n" }, "<leader>li", function()
            vim.lsp.inlay_hint(bufnr)
        end, { buffer = bufnr, silent = true, desc = "Toggle Inlay hint" })
    end
    vim.bo.tagfunc = nil
end

M.on_attach = on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
capabilities.textDocument.completion = {
    completionItem = {
        insertReplaceSupport = true,
        preselectSupport = false,
        snippetSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    },
}

M.capabilities = capabilities

local function setup_lsp(lsp_name, opts)
    local check_buf_is_float = require("float-preview").is_float

    opts.capabilities = capabilities
    opts.on_attach = on_attach
    local lsp = require("lspconfig")
    local conf = lsp[lsp_name]
    if vim.g.disable_lsp then
        opts.autostart = false
    end
    conf.setup(opts)

    local try_add = conf.manager.try_add
    conf.manager.try_add = function(bufnr, project_root)
        if check_buf_is_float(bufnr) then
            return
        end
        if check_buf_is_float(bufnr, vim.fn.bufname(bufnr)) then
            return
        end

        if is_large_file(bufnr, true) then
            vim.notify("disable lsp large buffer", vim.log.levels.DEBUG)
            return
        end

        return try_add(bufnr, project_root)
    end
end

M.setup_lsp = setup_lsp
return M
