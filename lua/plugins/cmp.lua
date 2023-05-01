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
    omni = "Omni",
    noice_popupmenu = "Native",
    ["vim-dadbod-completion"] = "DB",
    tags = "TG",
}

local enabled = function()
    local enabled = vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    return enabled
end

M.plugin = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "lukas-reineke/cmp-under-comparator",
        "lukas-reineke/cmp-rg",
        "saadparwaiz1/cmp_luasnip",
        "danymat/neogen",
        "hrsh7th/cmp-nvim-lua",
        "quangnguyen30192/cmp-nvim-tags",
        {
            "JMarkin/cmp-diag-codes",
        },
        {
            "tzachar/cmp-fuzzy-path",
            dependencies = {
                "tzachar/fuzzy.nvim",
                dependencies = {
                    "romgrk/fzy-lua-native",
                    build = "make",
                },
            },
        },
        {
            "hrsh7th/cmp-nvim-lsp",
            cond = not vim.g.disable_lsp,
        },
        {
            "hrsh7th/cmp-omni",
            cond = vim.g.disable_lsp,
        },
    },
    config = function()
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_snipmate").lazy_load()

        local neogen = require("neogen")

        local cmp = require("cmp")

        local move_down = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.in_snippet() and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif neogen.jumpable() then
                neogen.jump_next()
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
            elseif neogen.jumpable(true) then
                neogen.jump_prev()
            else
                fallback()
            end
        end, { "i", "s" })

        local sources = {
            { name = "nvim_lua" },
            { name = "fuzzy_path", keyword_length = 3 },
            { name = "diag-codes" },
        }

        local preselect = cmp.PreselectMode.Item

        if not vim.g.disable_lsp then
            table.insert(sources, { name = "nvim_lsp" })
        else
            vim.opt.omnifunc = "syntaxcomplete#Complete"
            table.insert(sources, { name = "omni" })
        end

        table.insert(
            sources,
            { name = "tags", max_item_count = 7, option = {
                complete_defer = 100,
            }
 }
        )
        table.insert(sources, {
            name = "vim-dadbod-completion",
            filetype = { "sql", "mssql", "plsql" },
        })
        table.insert(sources, {
            name = "rg",
            keyword_length = 2,
            max_item_count = 5,
        })
        table.insert(sources, { name = "luasnip", keyword_length = 2, max_item_count = 5 })

        cmp.setup({
            performance = {
                debounce = 60,
                throttle = 30,
                fetching_timeout = 100,
            },
            preselect = preselect,
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
                ["<CR>"] = cmp.mapping.confirm(),
                ["<Tab>"] = move_down,
                ["<S-Tab>"] = move_up,
            },
            sources = sources,
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.menu =
                        string.format("%-8s [%s]", vim_item.kind, menu_map[entry.source.name] or entry.source.name)

                    vim_item.kind = kind_icons[vim_item.kind]
                    return vim_item
                end,
            },
            window = {
                documentation = {
                    border = vim.g.floating_window_border_dark,
                },
                completion = {
                    border = vim.g.floating_window_border_dark,
                    pumheight = 0,
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                },
            },
        })
    end,
    event = { "InsertEnter" },
}

return M
