local M = {}

M.plugin = {
    "folke/noice.nvim",
    enabled = true,
    -- keys = { "/", "?", ":" },
    -- event = { "FileReadPre", "BufReadPre" },
    event = "VeryLazy",
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        cmdline = {
            format = {
                search_down = {
                    view = "cmdline",
                },
                search_up = {
                    view = "cmdline",
                },
            },
            view = "cmdline",
        },
        routes = {
            {
                view = "notify",
                filter = { event = "msg_showmode" },
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}

return M
