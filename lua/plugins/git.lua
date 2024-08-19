return {
    {
        "SuperBo/fugit2.nvim",
        enabled = false, -- ждем..
        opts = {
            width = 70,
            external_diffview = true, -- tell fugit2 to use diffview.nvim instead of builtin implementation.
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-lua/plenary.nvim",
            {
                "chrisgrieser/nvim-tinygit", -- optional: for Github PR view
                dependencies = { "stevearc/dressing.nvim" },
            },
        },
        cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
        keys = {
            { "<space>g", mode = "n", "<cmd>Fugit2<cr>" },
        },
    },
    {
        "FabijanZulj/blame.nvim",
        config = function()
            require("blame").setup({
                date_format = "%d.%m.%Y",
                virtual_style = "right",
                commit_detail_view = "vsplit",
                mappings = {
                    commit_info = "<cr>",
                    stack_push = "<TAB>",
                    stack_pop = "<BS>",
                    show_commit = "s",
                    close = { "<esc>", "q" },
                },
            })
        end,
        keys = {
            { "<leader>gB", ":BlameToggle window<cr>", desc = "Git blame" },
        },
    },
    {
        "moyiz/git-dev.nvim",
        opts = {
            cd_type = "tab",
            opener = function(dir)
                vim.cmd("tabnew")
                -- require("yazi").yazi({}, vim.fn.fnameescape(dir))
                vim.cmd("NvimTreeOpen " .. vim.fn.fnameescape(dir))
            end,
            git = {
                base_uri_format = "%s",
            },
        },
        keys = {
            {
                "<leader>o",
                function()
                    local repo = vim.fn.input("Repository name / URI: ")
                    if repo ~= "" then
                        require("git-dev").open(repo)
                    end
                end,
                desc = "[O]pen a remote git repository",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk({ preview = true })
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk({ preview = true })
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Git: prev hunk" })

                    -- Actions
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Git: blame line full" })
                end,
            })
        end,
        -- event = vim.g.pre_load_events,
        event = "VeryLazy",
        keys = {
            "<leader>gS",
            "<leader>gu",
            "<leader>gb",
            "[c",
            "]c",
            { "<space>s", ":Gitsign stage_hunk<cr>", desc = "Git: stage hunk", mode = { "n", "v" } },
            { "<space>S", ":Gitsign stage_buffer<cr>", desc = "Git: stage buffer" },
            { "<space>u", ":Gitsign undo_stage_hunk<cr>", desc = "Git: undo stage hunk", mode = { "n", "v" } },
            { "<leader>gr", ":Gitsign reset_hunk<cr>", desc = "Git: reset hunk", mode = { "n", "v" } },
            { "<leader>gR", ":Gitsign reset_buffer<cr>", desc = "Git: reset buffer" },
            { "<leader>gp", ":Gitsign preview_hunk_inline<cr>", desc = "Git: preview hunk" },
            { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git: select hunk", mode = { "o", "x" } },
        },
    },
}
