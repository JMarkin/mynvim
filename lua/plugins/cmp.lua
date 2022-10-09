local M = {}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

local menu_map = {
    gh_issues = "[Issues]",
    buffer = "[Buf]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[API]",
    path = "[Path]",
    luasnip = "[Snip]",
    tmux = "[Tmux]",
    look = "[Look]",
    rg = "[RG]",
    treesitter = "[TS]",
    spell = "[SP]",
}

local enabled = function ()
    local enabled = vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    enabled = enabled or require("cmp_dap").is_dap_buffer()
    enabled = enabled and not require("plugins.renamer").show_renamer()

    return enabled
end

M.config = function()
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()

    vim.cmd([[set completeopt=menu,menuone,noselect]])

    local cmp = require("cmp")

    local move_down = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.in_snippet() and luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" })

    local move_up = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.in_snippet() and luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" })

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require("cmp-under-comparator").under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
        view = {
            entries = "custom",
        },
        experimental = {
            ghost_text = true,
        },
        enabled = enabled,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = move_down,
            ["<S-Tab>"] = move_up,
        },
        sources = {
            { name = "nvim_lsp_signature_help", priority_weight = 120 },
            { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
            { name = "luasnip", priority_weight = 80 },
            {
                name = "vim-dadbod-completion",
                max_item_count = 20,
                priority_weight = 100,
                filetype = { "sql", "mssql", "plsql" },
            },
            {
                name = "tmux",
                priority_weight = 60,
                keyword_length = 5,
                max_item_count = 5,
            },
            { name = "path", priority_weight = 82, keyword_length = 2 },
            { name = "tags", priority_weight = 85, max_item_count = 20 },
            {
                name = "rg",
                keyword_length = 3,
                max_item_count = 5,
                priority_weight = 60,
            },
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = menu_map[entry.source.name] or string.format("[%s]", entry.source.name)

                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                return vim_item
            end,
        },
        window = {
            documentation = {
                border = vim.g.floating_window_border_dark,
            },
            completion = {
                border = vim.g.floating_window_border_dark,
            },
        },
    })

    require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = {
            { name = "dap" },
        },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        }),
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    require("cmp").setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
        }, {
            { name = "buffer" },
        }),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "cmdline", keyword_pattern = [[\!\@<!\w*]] },
        }),
    })
end

return M
