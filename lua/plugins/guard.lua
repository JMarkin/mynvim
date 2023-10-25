return {
    "nvimdev/guard.nvim",
    dev = true,
    dependencies = {
        {
            "nvimdev/guard-collection",
            dev = true,
        },
    },
    lazy = true,
    event = { "BufReadPost", "FileReadPost" },
    config = function()
        local ft = require("guard.filetype")

        ft("python"):fmt("ruff"):lint("dmypy")
        ft("lua"):fmt("stylua")
        ft("c,cpp"):lint("clang-tidy")
        ft("toml"):fmt("taplo")
        ft("typescript,javascript,typescriptreact,markdown"):fmt("prettier")

        require("guard").setup({
            -- the only options for the setup function
            fmt_on_save = false,
            -- Use lsp if no formatter was defined for this filetype
            lsp_as_default_formatter = true,
        })

        vim.keymap.set({ "n" }, "<space>bf", "<cmd>GuardFmt<cr>", { desc = "Format buffer" })
    end,
}
