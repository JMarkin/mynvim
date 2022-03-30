require("bufferline").setup({
    options = {
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",
        custom_filter = function(buf, buf_nums)
            local show_bf = true

            local is_help = vim.bo[buf].filetype == "help"
            show_bf = show_bf and not is_help

            local is_qf = vim.bo[buf].filetype == "qf"
            show_bf = show_bf and not is_qf

            -- local is_noname = vim.bo[buf].filetype == ""
            -- show_bf = show_bf and not is_noname

            return show_bf
        end,
        numbers = function(opts)
            return string.format("%s%s", opts.ordinal, opts.raise(opts.id))
        end,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " " or (e == "warning" and " " or "")
                s = s .. n .. sym
            end
            return s
        end,
        show_buffer_icons = true,
        show_close_icon = false,
        show_buffer_close_icons = false,
        indicator_icon = "▎",
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        always_show_bufferline = true,
        offsets = {
            {
                filetype = "Vista",
                text = "TagBar",
                highlight = "Directory",
                text_align = "right",
            },
        },
    },
})
