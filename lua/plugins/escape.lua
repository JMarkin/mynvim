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
        timeout = 200,
        default_mappings = false,
        mappings = {
            i = {
                j = {
                    k = "<Esc>",
                    j = "<Esc>",
                },
            },
            c = {
                j = {
                    k = "<Esc>",
                    j = "<Esc>",
                },
            },
            t = {
                j = {
                    k = "<Esc>",
                    j = "<Esc>",
                },
            },
            v = {
                j = {
                    k = "<Esc>",
                },
            },
            s = {
                j = {
                    k = "<Esc>",
                },
            },
        },
    },
}
