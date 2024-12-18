local is_not_mini = require("funcs").is_not_mini

return {
    "max397574/care.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "max397574/care-cmp",
    },
    config = function()
        vim.keymap.set("i", "<c-space>", function()
            require("care").api.complete()
        end)

        vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
        vim.keymap.set("i", "<c-a>", "<Plug>(CareClose)")
        vim.keymap.set("i", "<tab>", "<Plug>(CareSelectNext)")
        vim.keymap.set("i", "<s-tab>", "<Plug>(CareSelectPrev)")

        vim.keymap.set("i", "<c-d>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(4)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-d>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<c-e>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(-4)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-e>"), "n", false)
            end
        end)
    end,
}
