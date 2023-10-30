-- local kind_icons = {
--     Text = "",
--     Method = "󰆧",
--     Function = "󰊕",
--     Constructor = "",
--     Field = "󰇽",
--     Variable = "󰂡",
--     Class = "󰠱",
--     Interface = "",
--     Module = "",
--     Property = "󰜢",
--     Unit = "",
--     Value = "󰎠",
--     Enum = "",
--     Keyword = "󰌋",
--     Snippet = "",
--     Color = "󰏘",
--     File = "󰈙",
--     Reference = "",
--     Folder = "󰉋",
--     EnumMember = "",
--     Constant = "󰏿",
--     Struct = "",
--     Event = "",
--     Operator = "󰆕",
--     TypeParameter = "󰅲",
-- }

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

return {
    {
        "JMarkin/gentags.lua",
        -- dev = true,
        cond = vim.fn.executable("ctags") == 1,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gentags").setup({})
        end,
        event = "VeryLazy",
    },
    {
        "hrsh7th/nvim-cmp",
        -- dev = true,
        dependencies = {
            "lukas-reineke/cmp-under-comparator",
            "lukas-reineke/cmp-rg",
            {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    "L3MON4D3/LuaSnip",
                    build = "make install_jsregexp",
                },
            },
            "hrsh7th/cmp-omni",
            "danymat/neogen",
            -- "hrsh7th/cmp-nvim-lua",
            {
                "JMarkin/cmp-diag-codes",
                -- dev = true,
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                dependencies = { "onsails/lspkind.nvim" },
            },
            "rcarriga/cmp-dap",
            "quangnguyen30192/cmp-nvim-tags",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            luasnip.config.set_config({
                region_check_events = "InsertEnter",
                delete_check_events = "TextChanged,InsertLeave",
            })
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
                { name = "luasnip", keyword_length = 2, max_item_count = 5 },
                {
                    name = "tags",
                    option = {
                        -- this is the default options, change them if you want.
                        -- Delayed time after user input, in milliseconds.
                        complete_defer = 100,
                        -- Use exact word match when searching `taglist`, for better searching
                        -- performance.
                        exact_match = true,
                        -- Prioritize searching result for current buffer.
                        current_buffer_only = true,
                    },
                },
                -- { name = "treesitter", keyword_length = 2, max_item_count = 5 },
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
            }

            if vim.g.lsp_autostart then
                table.insert(sources, 1, { name = "diag-codes", in_comment = true })
                table.insert(sources, 1, { name = "nvim_lsp" })
            else
                table.insert(sources, 3, {
                    name = "omni",
                    option = {
                        disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
                    },
                })
            end

            local autocomplete = false

            if vim.g.lsp_autostart then
                local types = require("cmp.types")
                ---@diagnostic disable-next-line: cast-local-type
                autocomplete = {
                    types.cmp.TriggerEvent.TextChanged,
                }
            end

            cmp.setup({
                completion = { autocomplete = autocomplete },
                enabled = function()
                    local disabled = false
                    ---@diagnostic disable-next-line: deprecated
                    disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
                    disabled = disabled or (vim.fn.reg_recording() ~= "")
                    disabled = disabled or require("cmp_dap").is_dap_buffer()
                    return not disabled
                end,
                preselect = preselect,
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        require("cmp-under-comparator").under,
                        cmp.config.compare.score,
                        cmp.config.compare.kind,
                        cmp.config.compare.recently_used,
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
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),
                    ["<Tab>"] = move_down,
                    ["<S-Tab>"] = move_up,
                },
                sources = sources,
                formatting = {
                    format = require("lspkind").cmp_format({
                        -- symbol_map = kind_icons,
                        maxwidth = 50,
                        mode = "symbol",
                        menu = menu_map,
                    }),
                },
                window = vim.g.cmp_window,
            })

            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                },
            })
        end,
        event = { "InsertEnter" },
    },
}
