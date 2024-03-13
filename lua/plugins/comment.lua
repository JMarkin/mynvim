local is_large_file = require("largefiles").is_large_file
vim.g.skip_ts_context_commentstring_module = true

return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        enabled = false,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                -- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
                ignore = function()
                    return is_large_file(vim.api.nvim_get_current_buf(), true)
                end,
            })
        end,
        event = { "FileReadPre", "BufReadPre" },
    },
}
