local is_empty = function(str)
    return str == nil or str == ""
end

local shorting_target = 40

---shortens path by turning apple/orange -> a/orange
---@param path string
---@param sep string path separator
---@param max_len integer maximum length of the full filename string
---@return string
local function shorten_path(path, sep, max_len)
    local len = #path
    if len <= max_len then
        return path
    end

    local segments = vim.split(path, sep)
    for idx = 1, #segments - 1 do
        if len <= max_len then
            break
        end

        local segment = segments[idx]
        local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
        segments[idx] = shortened
        len = len - (#segment - #shortened)
    end

    return table.concat(segments, sep)
end

local get_filename = function(path)
    if is_empty(path) then
        return " %f"
    end
    return shorten_path(path, "/", shorting_target)
end

return {
    {
        "ramilito/winbar.nvim",
        event = "BufReadPre", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("winbar").setup({
                -- your configuration comes here, for example:
                icons = true,
                diagnostics = true,
                buf_modified = true,
                -- buf_modified_symbol = "M",
                -- or use an icon
                buf_modified_symbol = "●",
                dim_inactive = {
                    enabled = true,
                    highlight = "WinbarNC",
                    icons = true, -- whether to dim the icons
                    name = true, -- whether to dim the name
                },
            })
            local M = require("winbar")
            local config = require("winbar.config")
            local utils = require("winbar.utils")
            function M.get_winbar(opts)
                local diagnostics = {}
                local icon, hl = "", ""
                local should_dim = not opts.active and config.options.dim_inactive.enabled

                if config.options.diagnostics then
                    diagnostics = utils.get_diagnostics()
                end

                if config.options.icons then
                    icon, hl = utils.get_icon(M.icons_by_filename, M.icons_by_extension)
                end

                -- don't highlight icon if the window is not active
                if should_dim and config.options.dim_inactive.icons then
                    hl = config.options.dim_inactive.highlight
                end

                local sectionA = "  %#" .. hl .. "#" .. icon
                local sectionBhl = "Winbar"
                local sectionC = ""

                if vim.api.nvim_get_option_value("mod", {}) and config.options.buf_modified_symbol then
                    if diagnostics.level == "other" then
                        sectionBhl = "BufferCurrentMod"
                        sectionC = "%#" .. sectionBhl .. "# " .. config.options.buf_modified_symbol
                    else
                        sectionC = " " .. config.options.buf_modified_symbol
                    end
                end

                if diagnostics.level == "error" then
                    sectionBhl = "DiagnosticError"
                elseif diagnostics.level == "warning" then
                    sectionBhl = "DiagnosticWarn"
                elseif diagnostics.level == "info" then
                    sectionBhl = "DiagnosticInfo"
                elseif diagnostics.level == "hint" then
                    sectionBhl = "DiagnosticHint"
                end

                -- don't highlight name if the window is not active
                if should_dim and config.options.dim_inactive.name then
                    sectionBhl = config.options.dim_inactive.highlight
                end

                local filename = get_filename(vim.fn.expand("%"))

                local sectionB = "  " .. "%#" .. sectionBhl .. "#" .. filename .. sectionC
                -- local sectionB = "  " .. "%#" .. sectionBhl .. "#" .. "%t" .. sectionC
                return sectionA .. sectionB .. "%*"
            end
        end,
    },
}
