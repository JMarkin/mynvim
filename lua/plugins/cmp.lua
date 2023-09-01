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
    omni = "OMNI",
    noice_popupmenu = "N",
    ["vim-dadbod-completion"] = "DB",
    tags = "TG",
    ["diag-codes"] = "DC",
}

local enabled = function()
    local enabled = vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    enabled = enabled or require("cmp_dap").is_dap_buffer()
    return enabled
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "onsails/lspkind.nvim",
        "L3MON4D3/LuaSnip",
        "lukas-reineke/cmp-under-comparator",
        "lukas-reineke/cmp-rg",
        "saadparwaiz1/cmp_luasnip",
        "danymat/neogen",
        -- "hrsh7th/cmp-nvim-lua",
        {
            "JMarkin/cmp-diag-codes",
            -- dev = true,
            -- dir = "~/projects/cmp-diag-codes",
        },
        { "hrsh7th/cmp-path" },
        {
            "hrsh7th/cmp-nvim-lsp",
        },
        "rcarriga/cmp-dap",
        "ray-x/cmp-treesitter",
        {
            "JMarkin/gentags.lua",
            lazy = true,
            cond = vim.fn.executable("ctags") == 1,
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            opts = {},
        },
        "ofirgall/ofirkai.nvim",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        require("luasnip.loaders.from_snipmate").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load()

        -- require("luasnip").filetype_extend("python", { "django" })
        -- require("luasnip").filetype_extend("html", { "djangohtml" })

        local neogen = require("neogen")

        local cmp = require("cmp")

        local move_down = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
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

        local preselect = cmp.PreselectMode.None

        local sources = {
            { name = "diag-codes", in_comment = true },
            { name = "nvim_lsp" },
            { name = "luasnip", keyword_length = 2, max_item_count = 5 },
            { name = "treesitter", keyword_length = 2, max_item_count = 5 },
            {
                name = "vim-dadbod-completion",
                filetype = { "sql", "mssql", "plsql" },
            },
            {
                name = "rg",
                keyword_length = 2,
                max_item_count = 5,
                option = { additional_arguments = "--max-depth 4" },
            },
            { name = "path", keyword_length = 3 },
        }

        cmp.setup({
            performance = {
                debounce = 60,
                throttle = 30,
                fetching_timeout = 500,
                confirm_resolve_timeout = 80,
                async_budget = 1,
                max_view_entries = 100,
            },
            preselect = preselect,
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    require("cmp-under-comparator").under,
                    cmp.config.compare.scopes,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.recently_used,
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
            matching = {
                disallow_fuzzy_matching = false,
                disallow_fullfuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
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
                format = require("lspkind").cmp_format({
                    symbol_map = kind_icons,
                    maxwidth = 50,
                    mode = "symbol",
                    menu = menu_map,
                }),
            },
            window = require("ofirkai.plugins.nvim-cmp").window,
        })

        require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
                { name = "dap" },
            },
        })
    end,
    event = { "InsertEnter" },
}
