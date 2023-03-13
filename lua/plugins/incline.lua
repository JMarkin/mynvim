local get_icon_color = require("nvim-web-devicons").get_icon_color
local get_buf_option = vim.api.nvim_buf_get_option

local colors = require("colorscheme.colors")

local diagnostic_map = {}
diagnostic_map[vim.diagnostic.severity.ERROR] = { "", guifg = colors.red[1] }
diagnostic_map[vim.diagnostic.severity.WARN] = { "", guifg = colors.orange[1] }
diagnostic_map[vim.diagnostic.severity.INFO] = { "", guifg = colors.cyan[1] }
diagnostic_map[vim.diagnostic.severity.HINT] = { "", guifg = colors.ice[1] }

local function get_highest_diagnostic_severity(diagnostics)
    local highest_severity = 100
    for _, diagnostic in ipairs(diagnostics) do
        local severity = diagnostic.severity
        if severity < highest_severity then
            highest_severity = severity
        end
    end
    return highest_severity
end

local function get_status(bufnr, filename)
    local diagnostics = vim.diagnostic.get(bufnr)
    if vim.tbl_count(diagnostics) > 0 then
        local highest_severity = get_highest_diagnostic_severity(diagnostics)
        return diagnostic_map[highest_severity] or { "﫠", guifg = colors.gray[1] }
    else
        local filetype_icon, color = get_icon_color(filename)
        return { filetype_icon, guifg = color }
    end
end

require("incline").setup({
    debounce_threshold = { falling = 150, rising = 30 },
    render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":p:.")
        local status = get_status(props.buf, filename)
        local modified = get_buf_option(props.buf, "modified") and "*" or ""
        return {
            status,
            { " " },
            { modified, guifg = "grey" },
            { filename },
            { " " },
        }
    end,
    hide = {
        cursorline = true,
    },
    window = {
        margin = {
            vertical = 2,
        },
        -- placement = {
        --     vertical = "bottom",
        -- },
    },
})
