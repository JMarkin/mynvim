local function esc_clear()
    vim.api.nvim_input("<esc>")
    local current_line = vim.api.nvim_get_current_line()
    if current_line:match("^%s+j$") then
        vim.api.nvim_set_current_line("")
    end
end


return {
    "max397574/better-escape.nvim",
    opts = {
        mappings = {
            i = {
                j = {
                    k = "<Esc>",
                    n = "<Esc>",
                },
            },
            c = {
                j = {
                    k = "<Esc>",
                    n = "<Esc>",
                },
            },
            t = {
                j = {
                    k = "<Esc>",
                    n = "<Esc>",
                },
            },
            v = {
                j = {
                    n = "<Esc>",
                },
            },
            s = {
                j = {
                    n = "<Esc>",
                },
            },
        },
    },
}
