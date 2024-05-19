return {
    {
        "nvim-focus/focus.nvim",
        -- event = "VeryLazy",
        opts = {
            enable = true, -- Enable module
            commands = true, -- Create Focus commands
            autoresize = {
                enable = true, -- Enable or disable auto-resizing of splits
                width = 0, -- Force width for the focused window
                height = 0, -- Force height for the focused window
                minwidth = 15, -- Force minimum width for the unfocused window
                minheight = 15, -- Force minimum height for the unfocused window
                height_quickfix = 10, -- Set the height of quickfix panel
            },
        },
        init = function()
            local ignore_filetypes = {
                "dbui",
                "vista",
                "vista_kind",
                "NvimTree",
                "neo-tree",
                "undotree",
                "gundo",
                "blame",
                "toggleterm",
                "startuptime",
                "checkhealth",
                "netrw",
                "neotest-output",
                "neotest-output-panel",
                "neotest-summary",
                "sagaoutline",
                "alpha",
                "fzf",
                "NvimSeparator",
                "fidget",
                "cmp_menu",
            }
            local ignore_buftypes = { "nofile", "prompt", "popup", "quickfix" }

            local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

            vim.api.nvim_create_autocmd("WinEnter", {
                group = augroup,
                callback = function(_)
                    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
                        vim.w.focus_disable = true
                    else
                        vim.w.focus_disable = false
                    end
                end,
                desc = "Disable focus autoresize for BufType",
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = augroup,
                callback = function(_)
                    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                        vim.b.focus_disable = true
                    else
                        vim.b.focus_disable = false
                    end
                end,
                desc = "Disable focus autoresize for FileType",
            })
        end,
    },
    {
        "yorickpeterse/nvim-window",
        event = "BufAdd",
        keys = {
            {
                "<space>w",
                function()
                    require("nvim-window").pick()
                end,
                silent = true,
                desc = "Windows: pick",
                mode = { "n", "v" },
            },
        },
    },
}
