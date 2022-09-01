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
}

M.config = function()
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()

    vim.cmd([[set completeopt=menu,menuone,noselect]])

    local cmp = require("cmp")

    local move_down = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        -- elseif luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --     cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" })

    local move_up = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --     luasnip.jump(-1)
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
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
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
                name = "tmux",
                priority_weight = 60,
                keyword_length = 5,
                max_item_count = 5,
                option = {
                    all_panes = false,
                    label = "tmux",
                    trigger_characters = { "." },
                    trigger_characters_ft = {}, -- { filetype = { '.' } }
                },
            },
            { name = "path", priority_weight = 81 },
            { name = "tags", priority_weight = 85, max_item_count = 20 },
            {
                name = "rg",
                keyword_length = 5,
                max_item_count = 5,
                priority_weight = 60,
                option = {
                    additional_arguments = "--smart-case --hidden",
                },
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
            { name = "cmdline" },
        }),
    })

    require("settings.lang").config()

    require("trouble").setup({
        padding = false,
        auto_open = false,
        auto_close = true,
        auto_preview = true,
        auto_fold = true,
        mode = "document_diagnostics",
        action_keys = { -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>", "s" }, -- open buffer in new split
            open_vsplit = { "<c-v>", "v" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = { "o" }, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = { "zM", "zm" }, -- close all folds
            open_folds = { "zR", "zr" }, -- open all folds
            toggle_fold = { "zA", "za" }, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j", -- next item
        },
        use_diagnostic_signs = true,
    })

    vim.diagnostic.config({
        underline = true,
        signs = true,
        virtual_text = false,
        float = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_lines = false,
    })
end

return M
