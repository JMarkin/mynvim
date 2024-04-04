local autocmd = vim.api.nvim_create_autocmd
local groupid = vim.api.nvim_create_augroup

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

return {
    "b0o/incline.nvim",
    -- enabled = false,
    cond = not vim.g.started_by_firenvim,
    config = function()
        vim.opt.laststatus = 3
        require("incline").setup({
            debounce_threshold = { falling = 150, rising = 30 },
            render = function(props)
                if not vim.b[props.buf] then
                    vim.b[props.buf] = {}
                end
                if not vim.b[props.buf].incline_filename then
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), "%:~:.")
                    filename = shorten_path(filename, "/", shorting_target)
                    vim.b[props.buf].incline_filename = filename
                end
                if not vim.b[props.buf].incline_ft_icon_color then
                    vim.b[props.buf].incline_ft_icon, vim.b.incline_ft_color =
                        require("nvim-web-devicons").get_icon_color(vim.b.incline_filename)
                end

                local modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })
                        and "bold,undercurl,italic"
                    or "bold"
                local st_diag, diag = pcall(get_diagnostic_label, props)
                local st_git, git = pcall(get_git_diff, props)
                -- local st_noice, noice = pcall(get_noice_recording, props)

                local buffer = {
                    -- { st_noice and noice or "" },
                    { st_diag and diag or "" },
                    { st_git and git or "" },
                    { vim.b[props.buf].incline_ft_icon, guifg = vim.b[props.buf].incline_ft_color },
                    { " " },
                    { vim.b[props.buf].incline_filename, gui = modified },
                }
                return buffer
            end,
            hide = {
                cursorline = true,
            },
            window = {
                margin = {
                    vertical = 0,
                },
            },
        })
    end,
    event = { "BufReadPost", "FileReadPost" },
}
