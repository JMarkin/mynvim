return {
    "nvimdev/guard.nvim",
    -- enabled=false,
    dev = true,
    dependencies = {
        {
            "nvimdev/guard-collection",
            -- dev = true,
        },
    },
    lazy = true,
    event = { "BufReadPre", "FileReadPre" },
    config = function()
        local ft = require("guard.filetype")

        ft("python"):fmt("ruff"):lint("mypy")
        ft("lua"):fmt("stylua")
        ft("c,cpp"):lint("clang-tidy")
        -- ft("sql"):fmt("sqlfluff_fix"):append("sqlfluff"):lint("sqlfluff"):extra({ "--diallect", "postgres" })
        ft("toml"):fmt("taplo")
        ft("typescript,javascript,typescriptreact,markdown"):fmt("prettier")

        require("guard").setup({
            -- the only options for the setup function
            fmt_on_save = false,
            lint_on_change = false,
            -- Use lsp if no formatter was defined for this filetype
            lsp_as_default_formatter = true,
        })

        vim.keymap.set({ "n" }, "<space>bf", "<cmd>GuardFmt<cr>", { desc = "Format buffer" })
    end,
}
