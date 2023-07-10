---------Просмотр больших файлов
local large_files = "LargeFiles"
vim.api.nvim_create_augroup(large_files, { clear = true })

local max_file_size = 5
local max_file_size_readonly = 100
local max_line_length = 2000

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        local _, _, code = f:read(1)
        f:close()
        if code == 21 then
            return false
        end
    end
    return f ~= nil
end

local function maxline(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local file = vim.fn.expand(string.format("#%s:p", bufnr))
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

local function get_buf_size(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local ok, stats = pcall(function()
        return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
    end)
    if not (ok and stats) then
        return
    end
    return math.floor(0.5 + (stats.size / (1024 * 1024)))
end

local FILE_TYPE = {
    NORMAL = 0,
    LONG_LINE = 1,
    LARGE_SIZE = 2,
    READ_ONLY = 3,
}

local function is_large_file(bufnr, as_bool)
    local function wrap()
        local status_ok, is_large = pcall(vim.api.nvim_buf_get_var, bufnr, "large_buf")
        if status_ok then
            return is_large
        end
        local size = get_buf_size(bufnr)

        local _type = FILE_TYPE.NORMAL
        if not size then
            vim.api.nvim_buf_set_var(bufnr, "large_buf", _type)
            return
        end

        if size > max_file_size_readonly then
            vim.notify("LARGE FILE SIZE: READONLY " .. size, vim.log.levels.INFO)
            _type = FILE_TYPE.READ_ONLY
        elseif size > max_file_size then
            vim.notify("LARGE FILE SIZE " .. size, vim.log.levels.INFO)
            _type = FILE_TYPE.LARGE_SIZE
        else
            local _m = maxline(bufnr)
            if _m > max_line_length then
                vim.notify("LONG LINE " .. _m, vim.log.levels.INFO)
                _type = FILE_TYPE.LONG_LINE
            end
        end

        vim.api.nvim_buf_set_var(bufnr, "large_buf", _type)
        return _type
    end
    if not as_bool then
        return wrap()
    else
        local _t = wrap()
        return _t ~= FILE_TYPE.NORMAL
    end
end

local function optimize_buffer(args)
    local bufnr = args.buf

    local status_ok, _ = pcall(vim.api.nvim_buf_get_var, bufnr, "large_buf")
    if status_ok then
        return
    end

    local _type = is_large_file(bufnr)

    if _type == FILE_TYPE.NORMAL then
        return
    end

    vim.opt_local.cursorline = false
    vim.opt_local.linebreak = false
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
    vim.opt_local.hlsearch = false
    vim.opt_local.incsearch = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.swapfile = false
    vim.opt_local.bufhidden = "unload"
    vim.cmd("syntax clear")
    vim.opt_local.syntax = "off"
    vim.opt_local.list = false
    vim.opt_local.undolevels = -1
    vim.opt_local.undofile = false
    -- if vim.opt_local.eventignore == nil then
    --     vim.opt_local.eventignore = {}
    -- end
    -- vim.opt_local.eventignore:append(EVENTS)
    pcall(function()
        require("indent_blankline.commands").disable()
    end)
    pcall(vim.api.nvim_command, "UfoDisable")

    if _type == FILE_TYPE.READ_ONLY then
        vim.opt_local.buftype = "nowrite"
    end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
    group = large_files,
    pattern = { "*" },
    callback = optimize_buffer,
})

return {
    is_large_file = is_large_file,
    large_type = FILE_TYPE,
}
