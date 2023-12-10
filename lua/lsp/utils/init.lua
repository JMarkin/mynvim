local is_large_file = require("largefiles").is_large_file

local M = {}

local diag_opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
    scope = "cursor",
}

local keys = {
    {
        "<leader>sd",
        function()
            require("fzf-lua").lsp_definitions({ multiprocess = true })
        end,
        { desc = "Search: Definitions" },
    },
    {
        "<leader>sS",
        function()
            require("fzf-lua").lsp_live_workspace_symbols({ multiprocess = true })
        end,
        { desc = "Search: Symbols" },
    },
    {
        "gr",
        function()
            require("fzf-lua").lsp_finder({ multiprocess = true, ignore_current_line = true })
        end,
        { silent = true, desc = "GoTo: references" },
    },
    {
        "gdf",
        "<cmd>Lspsaga peek_definition<cr>",
        { desc = "GoTo: definition float" },
    },
    {
        "gh",
        "<cmd>Lspsaga finder<CR>",
        { desc = "Lsp: Finder" },
    },
    {

        "<leader>lk",
        "<cmd>Lspsaga hover_doc<CR>",
        { silent = true, desc = "Lang: hover doc" },
    },
    {

        "<leader>le",
        "<cmd>Lspsaga show_buf_diagnostics<CR>",
        { silent = true, desc = "Lang: show buf disagnostic" },
    },
    {

        "<leader>lE",
        "<cmd>Lspsaga show_workspace_diagnostics<CR>",
        { silent = true, desc = "Lang: show workspace disagnostic" },
    },
    {

        "<leader>la",
        "<cmd>Lspsaga code_action<cr>",
        { silent = true, desc = "Lang: code action" },
    },
    {
        "<leader>lr",
        "<cmd>Lspsaga rename<CR>",
        { silent = true, desc = "Lang: rename" },
    },
    {

        "<leader>lR",
        "<cmd>Lspsaga rename ++project<CR>",
        { silent = true, desc = "Lang: rename project" },
    },
    {
        "[e",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        { desc = "Jump: prev diag" },
    },
    {
        "]e",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        { desc = "Jump: next diag" },
    },
    {
        "[E",
        function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        { desc = "Jump: prev Error" },
    },
    {
        "]E",
        function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        { desc = "Jump: next Error" },
    },
    {
        "<space>t",
        ":Lspsaga outline<cr>",
        { desc = "Tagbar", silent = true },
    },
}

local on_attach = function(client, bufnr)
    if is_large_file(bufnr, true) then
        vim.lsp.buf_detach_client(bufnr, client.id)
        vim.bo[bufnr].tagfunc = nil
        return 0
    end

    for _, keymap in ipairs(keys) do
        keymap[3].buffer = bufnr
        vim.keymap.set("n", table.unpack(keymap))
    end

    local inlayhint = client.server_capabilities.inlayHintProvider
    if inlayhint then
        vim.keymap.set({ "n" }, "<leader>li", function()
            vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
        end, { buffer = bufnr, silent = true, desc = "Toggle Inlay hint" })
    end

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- local ok, sig_help = pcall(require, "lsp_signature")
    -- if ok then
    --     sig_help.on_attach({
    --         hint_enable = false,
    --         -- hint_prefix = "",
    --         -- hint_inline = function()
    --         --     return true
    --         -- end,
    --     }, bufnr)
    -- end

    return 1
end

M.on_attach = on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument = {
    foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    },
    completion = {
        dynamicRegistration = true,
        completionItem = {
            snippetSupport = true,
            commitCharactersSupport = true,
            deprecatedSupport = true,
            preselectSupport = true,
            tagSupport = {
                valueSet = {
                    1, -- Deprecated
                },
            },
            insertReplaceSupport = true,
            resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                    "sortText",
                    "filterText",
                    "insertText",
                    "textEdit",
                    "insertTextFormat",
                    "insertTextMode",
                },
            },
            insertTextModeSupport = {
                valueSet = {
                    1, -- asIs
                    2, -- adjustIndentation
                },
            },
            labelDetailsSupport = true,
        },
        contextSupport = true,
        insertTextMode = 1,
        completionList = {
            itemDefaults = {
                "commitCharacters",
                "editRange",
                "insertTextFormat",
                "insertTextMode",
                "data",
            },
        },
    },
}

M.capabilities = capabilities

local function setup_lsp(lsp_name, opts)
    local lsp_util = require("lspconfig.util")

    local _opts = {
        root_dir = lsp_util.root_pattern(table.unpack(vim.g.root_pattern)),
        capabilities = capabilities,
        on_attach = on_attach,
    }
    opts = vim.tbl_extend("force", opts, _opts)

    local lsp = require("lspconfig")
    local conf = lsp[lsp_name]
    conf.setup(opts)

    -- local try_add = conf.manager.try_add
    -- conf.manager.try_add = function(self, bufnr, project_root)
    --     if is_large_file(bufnr, true) then
    --         vim.notify("disable lsp large buffer", vim.log.levels.ERROR)
    --         vim.bo[bufnr].tagfunc = nil
    --         vim.bo[bufnr].omnifunc = "syntaxcomplete#Complete"
    --         return
    --     end
    --
    --     return try_add(self, bufnr, project_root)
    -- end
end

M.setup_lsp = setup_lsp
return M
