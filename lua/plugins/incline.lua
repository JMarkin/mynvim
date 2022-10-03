local get_icon_color = require("nvim-web-devicons").get_icon_color
local get_buf_option = vim.api.nvim_buf_get_option

local highlite = require("highlite")

local diagnostic_map = {}
diagnostic_map[vim.diagnostic.severity.ERROR] = { "", guifg = highlite.group("Error").fg }
diagnostic_map[vim.diagnostic.severity.WARN] = { "", guifg = highlite.group("Warning").fg }
diagnostic_map[vim.diagnostic.severity.INFO] = { "", guifg = highlite.group("Info").fg }
diagnostic_map[vim.diagnostic.severity.HINT] = { "", guifg = highlite.group("Warning").fg }

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
        return diagnostic_map[highest_severity] or { "﫠", guifg = highlite.group("Ignore").fg }
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
