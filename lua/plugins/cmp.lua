local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@diagnostic disable: missing-fields
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

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local _sources = {
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
}
local default_sources = vim.deepcopy(_sources)
table.insert(default_sources, {
    name = "omni",
    option = {
        disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
})

local lsp_sources = vim.deepcopy(_sources)
table.insert(lsp_sources, 1, { name = "diag-codes", in_comment = true })
table.insert(lsp_sources, 1, { name = "nvim_lsp" })
table.insert(lsp_sources, {
    name = "rg",
    keyword_length = 2,
    max_item_count = 5,
    option = { additional_arguments = "--max-depth 4" },
})

local default_comparators = function(compare)
    return {
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
        compare.length,
        compare.order,
    }
end

local python_comparators = function(compare)
    return {
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        require("cmp-under-comparator").under,
        compare.locality,
        compare.kind,
        compare.length,
        compare.order,
    }
end

local clang_comparators = function(compare)
    return {
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        require("clangd_extensions.cmp_scores"),
        compare.locality,
        compare.kind,
        compare.length,
        compare.order,
    }
end

local cmp_config = function(sources, buffer, comparators)
    comparators = comparators or default_comparators
    local luasnip = require("luasnip")

    local neogen = require("neogen")

    local cmp = require("cmp")
    local compare = require("cmp.config.compare")

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

    local setup = cmp.setup

    if buffer then
        setup = cmp.setup.buffer
    else
        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
                { name = "dap" },
            },
        })
    end

    setup({
        performance = {
            max_view_entries = 50,
        },
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
            priority_weight = 2,
            comparators = comparators(compare),
        },
        view = {
            entries = "custom",
        },
        experimental = {
            ghost_text = false,
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
            ["<C-e>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-a>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
                s = cmp.mapping.confirm({ select = true }),
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
end

local function cmp_cmdline(is_large)
    local cmp = require("cmp")

    if is_large then
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "cmdline_history", max_item_count = 2 },
            },
            performance = {
                max_view_entries = 10,
            },
        })
    else
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "cmdline_history", max_item_count = 2 },
                { name = "buffer" },
                { name = "rg" },
            },
            performance = {
                max_view_entries = 10,
            },
        })
    end

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "cmdline_history", max_item_count = 2 },
            { name = "path" },
            { name = "cmdline", option = {
                ignore_cmds = { "Man", "!" },
            } },
        }),
    })
end

local gr = augroup("cmp", { clear = true })

autocmd("FileType", {
    group = gr,
    pattern = "python",
    callback = function(opts)
        vim.b.comparators = python_comparators
    end,
})

autocmd("FileType", {
    group = gr,
    pattern = { "c", "cpp", "h" },
    callback = function(opts)
        vim.b.comparators = clang_comparators
    end,
})

autocmd("LspAttach", {
    group = gr,
    pattern = "*",
    callback = function(opts)
        cmp_config(lsp_sources, opts.buf, vim.b.comparators)
    end,
})

autocmd("User", {
    pattern = "LargeFile",
    group = gr,
    callback = function(opts)
        cmp_config(default_sources, opts.buf)
        cmp_cmdline(true)
    end,
})

return {
    {
        "JMarkin/gentags.lua",
        -- dev = true,
        cond = vim.fn.executable("ctags") == 1,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            async = false,
        },
        event = "VeryLazy",
    },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        lazy = true,
        config = function(_, opts)
            if opts then
                require("luasnip").config.setup(opts)
            end
            local luasnip = require("luasnip")

            luasnip.config.set_config({
                region_check_events = "InsertEnter",
                delete_check_events = "TextChanged,InsertLeave",
            })
            vim.tbl_map(function(type)
                require("luasnip.loaders.from_" .. type).lazy_load()
            end, { "vscode", "snipmate", "lua" })
            -- friendly-snippets - enable standardized comments snippets
            require("luasnip").filetype_extend("typescript", { "tsdoc" })
            require("luasnip").filetype_extend("javascript", { "jsdoc" })
            require("luasnip").filetype_extend("lua", { "luadoc" })
            require("luasnip").filetype_extend("python", { "pydoc" })
            require("luasnip").filetype_extend("rust", { "rustdoc" })
            require("luasnip").filetype_extend("cs", { "csharpdoc" })
            require("luasnip").filetype_extend("java", { "javadoc" })
            require("luasnip").filetype_extend("c", { "cdoc" })
            require("luasnip").filetype_extend("cpp", { "cppdoc" })
            require("luasnip").filetype_extend("php", { "phpdoc" })
            require("luasnip").filetype_extend("kotlin", { "kdoc" })
            require("luasnip").filetype_extend("ruby", { "rdoc" })
            require("luasnip").filetype_extend("sh", { "shelldoc" })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        -- dev = true,
        -- enabled = false,
        dependencies = {
            "lukas-reineke/cmp-under-comparator",
            "lukas-reineke/cmp-rg",
            "saadparwaiz1/cmp_luasnip",
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
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            cmp_config(default_sources)
            cmp_cmdline()
        end,
        event = { "InsertEnter" },
    },
}
