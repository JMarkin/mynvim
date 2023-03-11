---------Просмотр больших файлов
local large_files = "LargeFiles"
vim.api.nvim_create_augroup(large_files, { clear = true })

local max_file_size = 5242880 -- 5MB
local max_file_size_readonly = 10485760 -- 10MB
local disable_filetype = false

function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

function maxline(file)
    if not file_exists(file) then
        return 0
    end
    local max = 0
    for line in io.lines(file) do
        if max < #line then
            max = #line
        end
    end
    return max
end

local EVENTS = {
    "FileType",
    "CursorMoved",
    "DiffUpdated",
    "FileWriteCmd",
    "FileWritePost",
    "FileWritePre",
    "FilterReadPost",
    "FilterReadPre",
    "FilterWritePost",
    "FilterWritePre",
    "FocusGained",
    "FocusLost",
    "FuncUndefined",
    "ModeChanged",
    "SearchWrapped",
    "Syntax",
    "TextChanged",
    "User",
    "WinEnter",
    "WinNew",
    "WinScrolled",
    "WinResized",
    "OptionSet",
    "DirChanged",
    "TabEnter",
    "TabLeave",
    "ColorScheme",
    "ColorSchemePre",
    "CmdwinLeave",
    "BufEnter",
    "BufReadPost",
    "BufWinEnter",
    "BufWritePost",
    "BufWritePre",
    "BufWipeout",
}

function optimize_buffer()
    local file = vim.fn.expand("%:p")
    if file == nil or #file == 0 then
        if disable_filetype then
            vim.opt.eventignore:remove(EVENTS)
        end
        return
    end
    local size = vim.fn.getfsize(file)
    local disable = false
    if size > max_file_size then
        vim.notify("BIG FILE SIZE " .. size, vim.log.levels.WARN)
        disable = true
    end
    if not disable then
        local _m = maxline(file)
        if _m > vim.opt.synmaxcol._value then
            vim.notify("BIG FILE COLUMNS " .. _m, vim.log.levels.WARN)
            disable = true
        end
    end
    if disable then
        vim.opt.eventignore:append(EVENTS)
        vim.opt_local.swapfile = false
        vim.opt_local.bufhidden = "unload"
        vim.opt_local.syntax = "disable"
        vim.opt_local.wrap = false
        vim.opt_local.spell = false
        vim.opt_local.hlsearch = false
        vim.opt_local.incsearch = false

        if size > max_file_size_readonly then
            vim.opt_local.buftype = "nowrite"
            vim.opt_local.undolevels = -1
            vim.opt_local.undofile = false
        end
        disable_filetype = true
    else
        if disable_filetype then
            vim.opt.eventignore:remove(EVENTS)
            disable_filetype = false
        end
    end
end

vim.api.nvim_create_autocmd("BufReadPre", {
    group = large_files,
    pattern = { "*" },
    callback = function()
        optimize_buffer()
    end,
})
