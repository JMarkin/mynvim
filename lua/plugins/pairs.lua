return {
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter" },
        branch = "v0.6", --recomended as each new version will have breaking changes
        enabled = false,
        config = function()
            ---Get next two characters after cursor, whether in cmdline or normal buffer
            ---@return string: next two characters
            local function get_next_two_chars()
                local col, line
                if vim.fn.mode():match("^c") then
                    col = vim.fn.getcmdpos()
                    line = vim.fn.getcmdline()
                else
                    col = vim.fn.col(".")
                    line = vim.api.nvim_get_current_line()
                end
                return line:sub(col, col + 1)
            end

            -- Matches strings that start with:
            -- keywords: \k
            -- opening pairs: (, [, {, \(, \[, \{
            local IGNORE_REGEX = vim.regex([=[^\%(\k\|\\\?[([{]\)]=])

            require("ultimate-autopair").setup({
                extensions = {
                    -- Improve performance when typing fast, see
                    -- https://github.com/altermo/ultimate-autopair.nvim/issues/74
                    tsnode = false,
                    filetype = { tree = false },
                    cond = {
                        cond = function(f)
                            return not f.in_cmdline()
                                and not f.in_macro()
                                -- Disable autopairs if followed by a keyword or an opening pair
                                and not IGNORE_REGEX:match_str(get_next_two_chars())
                        end,
                    },
                },
                { "\\(", "\\)" },
                { "\\[", "\\]" },
                { "\\{", "\\}" },
                { "[=[", "]=]", ft = { "lua" } },
                { "<<<", ">>>", ft = { "cuda" } },
                {
                    "/*",
                    "*/",
                    ft = { "c", "cpp", "cuda" },
                    newline = true,
                    space = true,
                },
            })
        end,
    },
    { "echasnovski/mini.pairs", enabled = true, event = { "InsertEnter", "CmdwinEnter" }, opts = {} },
}
