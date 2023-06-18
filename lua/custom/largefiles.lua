---------Просмотр больших файлов
local large_files = "LargeFiles"
vim.api.nvim_create_augroup(large_files, { clear = true })

local max_file_size = 5242880 -- 5MB
local max_file_size_readonly = 10485760 -- 10MB
local disable_filetype = false

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

local function maxline(file)
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

local function is_large_file(buf)
    local file
    if buf == nil then
        file = vim.fn.expand("%:p")
    else
        file = vim.fn.expand(string.format("#%s:p", buf))
    end

    if file == nil or #file == 0 then
        if disable_filetype then
            vim.opt.eventignore:remove(EVENTS)
        end
        return
    end
    local size = vim.fn.getfsize(file)
    local disable = false
    local big_line = false

    if size > max_file_size then
        vim.notify("BIG FILE SIZE " .. size, vim.log.levels.INFO)
        disable = true
    end
    if not disable then
        local _m = maxline(file)
        if _m > vim.opt.synmaxcol._value then
            vim.notify("BIG FILE COLUMNS " .. _m, vim.log.levels.INFO)
            big_line = true
        end
    end

    vim.b.large_buf = disable or big_line
    return disable, big_line, size
end

local is_disabled = false

local function optimize_buffer(args)
    local disable, big_line, size = is_large_file(args.buf)

    if disable then
        if vim.opt.eventignore == nil then
            vim.opt.eventignore = {}
        end
        vim.opt.eventignore:append(EVENTS)
        vim.opt_local.swapfile = false
        vim.opt_local.bufhidden = "unload"
        vim.opt_local.syntax = "disable"

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

    if disable or big_line then
        is_disabled = true
        vim.opt_local.wrap = false
        vim.opt_local.spell = false
        vim.opt_local.hlsearch = false
        vim.opt_local.incsearch = false
        vim.opt_local.foldmethod = "manual"

        vim.api.nvim_command("IndentBlanklineDisable")
        pcall(vim.api.nvim_command, "UfoDisable")
    else
        if is_disabled then
            vim.api.nvim_command("IndentBlanklineEnable")
            pcall(vim.api.nvim_command, "UfoEnable")
        end
    end
end

vim.api.nvim_create_autocmd({"BufReadPre", "FileReadPre"}, {
    group = large_files,
    pattern = { "*" },
    callback = optimize_buffer,
})

return {
    is_large_file = is_large_file,
}
