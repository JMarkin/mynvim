local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local is_not_mini = require("funcs").is_not_mini

local enabled = true

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
    cmp_ai = "AI",
}

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local mini_sources = {
    {
        name = "tags",
        option = {
            -- this is the default options, change them if you want.
            -- Delayed time after user input, in milliseconds.
            complete_defer = 50,
            -- Use exact word match when searching `taglist`, for better searching
            -- performance.
            exact_match = true,
            -- Prioritize searching result for current buffer.
            current_buffer_only = true,
        },
    },
    {
        name = "omni",
        option = {
            disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
        },
        max_item_count = 20,
    },
}

local _sources = {
    { name = "luasnip", keyword_length = 1, max_item_count = 5 },
    {
        name = "tags",
        option = {
            -- this is the default options, change them if you want.
            -- Delayed time after user input, in milliseconds.
            complete_defer = 50,
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
        max_item_count = 20,
    },
}
local default_sources = vim.deepcopy(_sources)
table.insert(default_sources, {
    name = "omni",
    option = {
        disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
    max_item_count = 20,
})

local lsp_sources = vim.deepcopy(_sources)
table.insert(lsp_sources, 1, { name = "diag-codes", in_comment = true })
table.insert(lsp_sources, 1, { name = "nvim_lsp", max_item_count = 20 })
table.insert(lsp_sources, {
    name = "rg",
    keyword_length = 2,
    max_item_count = 5,
    option = { additional_arguments = "--max-depth 4" },
})

local nvim_sources = vim.deepcopy(lsp_sources)
table.insert(nvim_sources, 1, { name = "nvim_lua" })

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

local rust_comparators = function(compare)
    return {
        -- deprioritize `.box`, `.mut`, etc.
        require("cmp-rust").deprioritize_postfix,
        -- deprioritize `Borrow::borrow` and `BorrowMut::borrow_mut`
        require("cmp-rust").deprioritize_borrow,
        -- deprioritize `Deref::deref` and `DerefMut::deref_mut`
        require("cmp-rust").deprioritize_deref,
        -- deprioritize `Into::into`, `Clone::clone`, etc.
        require("cmp-rust").deprioritize_common_traits,
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

---Hack: `nvim_lsp` and `nvim_lsp_signature_help` source still use
---deprecated `vim.lsp.buf_get_clients()`, which is slower due to
---the deprecation and version check in that function. Overwrite
---it using `vim.lsp.get_clients()` to improve performance.
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.buf_get_clients(bufnr)
    return vim.lsp.get_clients({ buffer = bufnr })
end

---@type string?
local last_key

vim.on_key(function(k)
    last_key = k
end)

local cmp_config = function(sources, buffer, comparators)
    comparators = comparators or default_comparators
    local _, luasnip = pcall(require, "luasnip")

    local _, neogen = pcall(require, "neogen")

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
            async_budget = 64,
            max_view_entries = 64,
        },
        enabled = function()
            local disabled = false
            ---@diagnostic disable-next-line: deprecated
            disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
            disabled = disabled or (vim.fn.reg_recording() ~= "")
            disabled = disabled or (vim.fn.reg_executing() ~= "")
            if is_not_mini() then
                disabled = disabled or require("cmp_dap").is_dap_buffer()
            end
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
                if is_not_mini() then
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end
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
                    if cmp.visible() and cmp.get_active_entry() or vim.fn.pumvisible() > 0 then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
                s = cmp.mapping.confirm({ select = true }),
            }),
            ["<Tab>"] = move_down,
            ["<S-Tab>"] = move_up,
            ["<C-]>"] = cmp.mapping(
                cmp.mapping.complete({
                    config = {
                        sources = cmp.config.sources({
                            { name = "cmp_ai" },
                        }),
                    },
                }),
                { "i" }
            ),
        },
        sources = sources,
        formatting = {
            fields = { "abbr", "kind", "menu" },
            format = function(entry, vim_item)
                if entry.source.name == "cmp_ai" then
                    vim_item.menu = menu_map[entry.source.name]
                    local detail = (entry.completion_item.labelDetails or {}).detail
                    vim_item.kind = ""
                    if detail and detail:find(".*%%.*") then
                        vim_item.kind = vim_item.kind .. " " .. detail
                    end

                    if (entry.completion_item.data or {}).multiline then
                        vim_item.kind = vim_item.kind .. " " .. "[ML]"
                    end
                    vim_item.abbr = string.sub(vim_item.abbr, 1, 80)
                    return vim_item
                end

                if not is_not_mini() then
                    return vim_item
                end
                local resp = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50, menu = menu_map })(
                    entry,
                    vim_item
                )
                return resp
            end,
        },
        window = {
            completion = {
                -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                col_offset = 1,
                side_padding = 0,
            },
            documentation = {
                max_width = 80,
                max_height = 20,
                border = "solid",
            },
        },
    })
end

local function cmp_cmdline(is_large)
    local cmp = require("cmp")

    if is_large then
        cmp.setup.cmdline({ "/", "?" }, { enabled = false })
    else
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "cmdline_history", max_item_count = 2 },
                { name = "buffer" },
            },
            performance = {
                max_view_entries = 10,
            },
            view = {
                entries = { name = "wildmenu", separator = " | " },
            },
        })
    end

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "cmdline_history", max_item_count = 2 },
            { name = "cmdline", option = {
                ignore_cmds = { "Man" },
            } },
        }),
    })
end

if enabled then
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
        pattern = "rust",
        callback = function(opts)
            vim.b.comparators = rust_comparators
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

    -- autocmd("FileType", {
    --     group = gr,
    --     pattern = { "lua" },
    --     callback = function(opts)
    --         local current_file = vim.fn.expand("%:p")
    --
    --         local base_vimruntime_dir = vim.api.nvim_call_function("finddir", "vimruntime")
    --
    --         if string.find(base_vimruntime_dir, current_file) then
    --             cmp_config(nvim_sources, opts.buf, vim.b.comparators)
    --         end
    --     end,
    -- })

    autocmd("User", {
        pattern = "LargeFile",
        group = gr,
        callback = function(opts)
            cmp_config(default_sources, opts.buf)
            -- cmp_cmdline(true)
        end,
    })
end

return {
    {
        enabled = enabled,
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        cond = is_not_mini,
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
        enabled = enabled,
        lazy = true,
        -- dev = true,
        dependencies = {
            { "lukas-reineke/cmp-under-comparator", cond = is_not_mini, lazy = true },
            { "ryo33/nvim-cmp-rust", cond = is_not_mini, lazy = true },
            { "lukas-reineke/cmp-rg", cond = is_not_mini },
            { "saadparwaiz1/cmp_luasnip", cond = is_not_mini },
            "hrsh7th/cmp-omni",
            { "danymat/neogen", cond = is_not_mini },
            { "hrsh7th/cmp-nvim-lua", cond = is_not_mini },
            {
                "JMarkin/cmp-diag-codes",
                cond = is_not_mini,
                -- dev = true,
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                dependencies = { "onsails/lspkind.nvim" },
                cond = is_not_mini,
            },
            { "rcarriga/cmp-dap", cond = is_not_mini },
            "quangnguyen30192/cmp-nvim-tags",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            {
                "tzachar/cmp-ai",
                cond = is_not_mini,
                config = function()
                    local cmp_ai = require("cmp_ai.config")

                    cmp_ai:setup({
                        max_lines = 200,
                        provider = "Ollama",
                        provider_options = {
                            model = "codellama:7b-code",
                        },
                        notify = true,
                        notify_callback = function(msg)
                            vim.notify(msg)
                        end,
                        run_on_every_keystroke = false,
                    })
                end,
            },
        },
        config = function()
            local cmp = require("cmp")
            local cmp_core = require("cmp.core")

            ---@type integer
            local last_changed = 0
            local _cmp_on_change = cmp_core.on_change
            local string_byte_c = string.byte("c")
            ---Improves performance when inserting in large files
            ---@diagnostic disable-next-line: duplicate-set-field
            function cmp_core.on_change(self, trigger_event)
                -- Don't know why but inserting spaces/tabs causes higher latency than other
                -- keys, e.g. when holding down 's' the interval between keystrokes is less
                -- than 32ms (80 repeats/s keyboard), but when holding spaces/tabs the
                -- interval increases to 100ms, guess is is due ot some other plugins that
                -- triggers on spaces/tabs
                -- Spaces/tabs are not useful in triggering completions in insert mode but can
                -- be useful in command-line autocompletion, so ignore them only when not in
                -- command-line mode
                if (last_key == " " or last_key == "\t") and string.byte(vim.fn.mode(), 1) ~= string_byte_c then
                    return
                end

                _cmp_on_change(self, trigger_event)

                -- local now = vim.uv.now()
                -- local fast_typing = now - last_changed < 32
                -- last_changed = now
                --
                -- if not fast_typing or trigger_event ~= "TextChanged" or cmp.visible() then
                --     _cmp_on_change(self, trigger_event)
                --     return
                -- end
                --
                -- vim.defer_fn(function()
                --     if last_changed == now then
                --         _cmp_on_change(self, trigger_event)
                --     end
                -- end, 200)
            end

            if is_not_mini() then
                cmp_config(default_sources)
            else
                cmp_config(mini_sources)
            end
            -- cmp_cmdline()

            -- cmp does not work with cmdline with type other than `:`, '/', and '?', e.g.
            -- it does not respect the completion option of `input()`/`vim.ui.input()`, see
            -- https://github.com/hrsh7th/nvim-cmp/issues/1690
            -- https://github.com/hrsh7th/nvim-cmp/discussions/1073
            cmp.setup.cmdline("@", { enabled = false })
            cmp.setup.cmdline(">", { enabled = false })
            cmp.setup.cmdline("-", { enabled = false })
            cmp.setup.cmdline("=", { enabled = false })
        end,
        event = { "InsertEnter", "CmdlineEnter" },
    },
}
