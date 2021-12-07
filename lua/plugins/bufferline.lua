require("bufferline").setup{
    options = {
        custom_filter = function(buf, buf_nums)
            local show_bf = true
            
            local is_help = vim.bo[buf].filetype == "help"
            show_bf = show_bf and not is_help
            
            local is_qf = vim.bo[buf].filetype == "qf"
            show_bf = show_bf and not is_qf
            
            return show_bf
        end,
        numbers=function(opts)
            return string.format('%s%s', opts.ordinal, opts.raise(opts.id))
        end,
        diagnostics="nvim_lsp",
        diagnostics_update_in_insert=true,
        show_close_icon=false,
        show_buffer_close_icons=false,
        offsets = {
          {
            filetype = "NvimTree",
            text = function()
              return vim.fn.getcwd()
            end,
            highlight = "Directory",
            text_align = "left"
          },
          {
            filetype = "Vista",
            text = "TagBar",
            highlight = "Directory",
            text_align = "right"
          }

        }
    }
}

