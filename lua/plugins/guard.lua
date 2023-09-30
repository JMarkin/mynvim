return {
    "nvimdev/guard.nvim",
    dependencies = {
        {
            "nvimdev/guard-collection",
            dev = true,
            dir = "~/projects/guard-collection",
        },
    },
    event = "LspAttach",
    config = function()
        local ft = require("guard.filetype")

        ft("python"):fmt("ruff_fix"):append("ruff"):lint("ruff")
        ft("lua"):fmt("lsp"):append("stylua")
        ft("typescript,javascript,typescriptreact"):fmt("prettier")

        require("guard").setup({
            -- the only options for the setup function
            fmt_on_save = false,
            -- Use lsp if no formatter was defined for this filetype
            lsp_as_default_formatter = true,
        })
        vim.keymap.set("n", "<space>bf", "<cmd>GuardFmt<cr>", { desc = "Format buffer" })
    end,
}
