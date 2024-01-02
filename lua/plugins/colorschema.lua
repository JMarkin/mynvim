vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LocalHighlight", { link = "Debug" })
    end,
})

return {
    {
        "sekke276/dark_flat.nvim",
        enabled = false,
        lazy = false,
        priority = math.huge,
        config = function()
            require("dark_flat").setup({
                transparent = true,
                italics = true,
            })
            vim.api.nvim_command("colorscheme dark_flat")
            vim.g.lualine_theme = "dark_flat"
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        enabled = true,
        lazy = false,
        priority = math.huge,
        config = function()
            require("cyberdream").setup({
                -- Recommended - see "Configuring" below for more config options
                transparent = true,
                italic_comments = true,
                hide_fillchars = false,
            })
            vim.api.nvim_command("colorscheme cyberdream")
            vim.g.lualine_theme = "cyberdream"
        end,
    },
}
