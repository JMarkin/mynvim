local function get_diagnostic_label(props)
    local icons = { error = "", warn = "", info = "", hint = "󰌵" }
    local label = {}

    for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
            table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
        end
    end
    if #label > 0 then
        table.insert(label, { "| " })
    end
    return label
end
local function get_git_diff(props)
    local icons = { removed = "", changed = "", added = "" }
    local labels = {}
    local signs = vim.b.gitsigns_status_dict

    local group_map = { removed = "Delete", changed = "Change", added = "Add" }

    for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
            local group = "Diff" .. group_map[name]
            table.insert(labels, { icon .. " " .. signs[name] .. " ", group = group })
        end
    end
    if #labels > 0 then
        table.insert(labels, { "| " })
    end
    return labels
end

local function get_noice_recording(props)
    local statusline = require("noice").api.statusline.mode

    local label = {}
    local m = statusline.get()
    local idx = m:find("@")
    if idx then
        m = m:sub(idx, #m) .. " "
        table.insert(label, {
            m,
            guifg = "#00b0ff",
        })
    end
    if #label > 0 then
        table.insert(label, { "| " })
    end
    return label
end

return {
    "b0o/incline.nvim",
    init = function()
        vim.opt.laststatus = 3
    end,
    cond = not vim.g.started_by_firenvim,
    config = function()
        require("incline").setup({
            debounce_threshold = { falling = 150, rising = 30 },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
                local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,undercurl,italic"
                    or "bold"
                local st_diag, diag = pcall(get_diagnostic_label, props)
                local st_git, git = pcall(get_git_diff, props)
                local st_noice, noice = pcall(get_noice_recording, props)

                local buffer = {
                    { st_noice and noice or "" },
                    { st_diag and diag or "" },
                    { st_git and git or "" },
                    { ft_icon, guifg = ft_color },
                    { " " },
                    { filename, gui = modified },
                }
                return buffer
            end,
            hide = {
                cursorline = true,
            },
            window = {
                margin = {
                    vertical = 2,
                },
            },
        })
    end,
    event = { "BufReadPost", "FileReadPost" },
}
