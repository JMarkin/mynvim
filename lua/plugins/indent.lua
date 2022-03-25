local present, indt = pcall(require, "indent_blankline")
if present then
    indt.setup({
        -- space_char_blankline = " ",
        -- show_current_context = true,
        -- show_current_context_start = true,
        show_end_of_line = true,
    })
end
