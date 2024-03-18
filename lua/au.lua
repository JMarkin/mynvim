local autocmd = vim.api.nvim_create_autocmd
local groupid = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    group = groupid("hl_yank", { clear = true }),
    pattern = "*",
    desc = "hightlight on yank",
    callback = function()
        vim.highlight.on_yank({
            higroup = "DiffChange",
            timeout = 100,
        })
    end,
})

autocmd({ "BufReadPre", "FileReadPre" }, {
    group = groupid("large_fiels", { clear = true }),
    pattern = { "*" },
    callback = require("largefiles").optimize_buffer,
})

autocmd({ "LspAttach" }, {
    group = groupid("lsp_attach", { clear = true }),
    pattern = { "*" },
    callback = function()
        vim.b.lsp_attached = true
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = groupid("checktime", { clear = true }),
    command = "checktime",
})

-- Format Option
local format_options = groupid("Format Options", { clear = true })
autocmd("BufReadPost", {
    callback = function()
        vim.opt_local.formatoptions = vim.opt_local.formatoptions
            - "a" -- Auto formatting is BAD.
            - "t" -- Don't auto format my code. I got linters for that.
            + "c" -- In general, I like it when comments respect textwidth
            + "q" -- Allow formatting comments w/ gq
            - "o" -- O and o, don't continue comments
            + "r" -- But do continue when pressing enter.
            + "n" -- Indent past the formatlistpat, not underneath it.
            + "j" -- Auto-remove comments if possible.
            - "2" -- I'm not in gradeschool anymore
            + "p" --
    end,
    group = format_options,
})

-- Use 'q' to quit from common plugins
autocmd("FileType", {
    group = groupid("quit", { clear = true }),
    pattern = {
        "help",
        "man",
        "lspinfo",
        "trouble",
        "null-ls-info",
        "qf",
        "notify",
        "startuptime",
        "checkhealth",
        "netrw",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "vista_kind",
        "sagaoutline",
    },
    callback = function(event)
        vim.opt_local.wrap = false
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = groupid("spell", { clear = true }),
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
    group = groupid("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- copy from https://github.com/Bekaboo/nvim/blob/master/lua/core/autocmds.lua

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function augroup(group, ...)
    local id = groupid(group, { clear = true })
    for _, a in ipairs({ ... }) do
        a[2].group = id
        autocmd(unpack(a))
    end
end

augroup("SplitRightDefaults", {
    "BufWinEnter",
    {
        desc = "split right help, preview",
        pattern = "*",
        callback = function(info)
            local change = false
            if vim.o.filetype == "help" then
                change = true
            end

            if vim.o.previewwindow then
                change = true
            end

            if change then
                vim.cmd.wincmd("L")
            end
        end,
    },
})

augroup("SYNTAX", {
    "FileType",
    {
        desc = "syntax set",
        callback = function(info)
            vim.bo[info.buf].syntax = vim.bo[info.buf].ft
        end,
    },
})

augroup("OmniFunc", {
    "FileType",
    {
        desc = "Smart set omnifunc",
        callback = function(info)
            vim.bo[info.buf].omnifunc = "syntaxcomplete#Complete"
        end,
    },
})

-- augroup("WinCloseJmp", {
--     "WinClosed",
--     {
--         nested = true,
--         desc = "Jump to last accessed window on closing the current one.",
--         command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
--     },
-- })

-- number toggle
augroup("NumberToggle", {
    { "InsertLeave", "CmdlineLeave" },
    {
        callback = function()
            if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
                vim.opt.relativenumber = true
            end
        end,
    },
}, {
    { "InsertEnter", "CmdlineEnter" },
    {

        callback = function()
            if vim.o.nu then
                vim.opt.relativenumber = false
                vim.cmd("redraw")
            end
        end,
    },
})

-- Persistent Folds
augroup("auto_view", {
    { "BufWinLeave", "BufWritePost", "WinLeave" },
    {
        desc = "Save view with mkview for real files",
        callback = function(args)
            if vim.b[args.buf].view_activated then
                vim.cmd.mkview({ mods = { emsg_silent = true } })
            end
        end,
    },
}, {
    "BufWinEnter",
    {
        desc = "Try to load file view if available and enable view saving for real files",
        callback = function(args)
            if not vim.b[args.buf].view_activated then
                local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
                local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
                local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
                if
                    buftype == ""
                    and filetype
                    and filetype ~= ""
                    and not vim.tbl_contains(ignore_filetypes, filetype)
                then
                    vim.b[args.buf].view_activated = true
                    vim.cmd.loadview({ mods = { emsg_silent = true } })
                end
            end
        end,
    },
})
