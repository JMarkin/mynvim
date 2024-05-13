local M = {}


local kind_priority = {
    Parameter = 14,
    Variable = 12,
    Field = 11,
    Property = 11,
    Constant = 10,
    Enum = 10,
    EnumMember = 10,
    Event = 10,
    Function = 10,
    Method = 10,
    Operator = 10,
    Reference = 10,
    Struct = 10,
    File = 8,
    Folder = 8,
    Class = 5,
    Color = 5,
    Module = 5,
    Keyword = 2,
    Constructor = 1,
    Interface = 1,
    Snippet = 0,
    Text = 1,
    TypeParameter = 1,
    Unit = 1,
    Value = 1,
}

M.menu_map = {
    gh_issues = "ISSUE",
    buffer = "BUF",
    nvim_lsp = "LSP",
    nvim_lua = "API",
    path = "PATH",
    luasnip = "SNIP",
    tmux = "TX",
    look = "LK",
    rg = "RG",
    treesitter = "TS",
    spell = "SP",
    omni = "OMNI",
    noice_popupmenu = "N",
    ["vim-dadbod-completion"] = "DB",
    tags = "TG",
    ["diag-codes"] = "DC",
    cmp_ai = "AI",
}

function M.has_words_after()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line, line + 1, true)[1]:sub(col, col):match("%s") == nil
end

M.put_down_snippet = function(entry1, entry2)
    local types = require("cmp.types")
    local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
    local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
    kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
    kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
    if kind1 ~= kind2 then
        if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
        end
        if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
        end
    end
    return nil
end

M.lspkind_comparator = function()
    local lsp_types = require("cmp.types").lsp
    return function(entry1, entry2)
        if entry1.source.name ~= "nvim_lsp" then
            if entry2.source.name == "nvim_lsp" then
                return false
            else
                return nil
            end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
        if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
            kind1 = "Parameter"
        end
        if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
            kind2 = "Parameter"
        end

        local priority1 = kind_priority[kind1] or 0
        local priority2 = kind_priority[kind2] or 0
        if priority1 == priority2 then
            return nil
        end
        return priority2 < priority1
    end
end

return M
