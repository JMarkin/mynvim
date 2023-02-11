local theme = {
    fill = "TabLineFill",
    head = "TabLine",
    current_tab = "TabLineSel",
    tab = "TabLine",
    win = "TabLine",
    tail = "TabLine",
}
require("tabby.tabline").set(function(line)
    return {
        {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
                line.sep("", hl, theme.fill),
                tab.is_current() and "" or "",
                tab.number(),
                tab.name(),
                tab.close_btn(""),
                line.sep("", hl, theme.fill),
                hl = hl,
                margin = " ",
            }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
                line.sep("", theme.win, theme.fill),
                win.is_current() and "" or "",
                win.buf_name(),
                line.sep("", theme.win, theme.fill),
                hl = theme.win,
                margin = " ",
            }
        end),
        {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
        },
        hl = theme.fill,
    }
end)

vim.keymap.set("n", "<leader>ta", ":$tabnew<CR>", { desc = "Tabs: new" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Tabs: close" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Tabs: close other tabs" })
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Tabs: next" })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Tabs: prev" })
-- move current tab to previous position
vim.keymap.set("n", "<leader>tmp", ":-tabmove<CR>", { desc = "Tabs: move to prev" })
-- move current tab to next position
vim.keymap.set("n", "<leader>tmn", ":+tabmove<CR>", { desc = "Tabs: move to next" })
