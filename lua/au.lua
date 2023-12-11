local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("hl_yank", { clear = true }),
    pattern = "*",
    desc = "hightlight on yank",
    callback = function()
        vim.highlight.on_yank({
            higroup = "ModesCopy",
            timeout = 100,
        })
    end,
})

autocmd({ "BufReadPre", "FileReadPre" }, {
    group = augroup("large_fiels", { clear = true }),
    pattern = { "*" },
    callback = require("largefiles").optimize_buffer,
})

autocmd({ "LspAttach" }, {
    group = augroup("lsp_attach", { clear = true }),
    pattern = { "*" },
    callback = function()
        vim.b.lsp_attached = true
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime", { clear = true }),
    command = "checktime",
})

-- Format Option
local format_options = augroup("Format Options", { clear = true })
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
    end,
    group = format_options,
})

-- Use 'q' to quit from common plugins
autocmd("FileType", {
    group = augroup("quit", { clear = true }),
    pattern = {
        "help",
        "man",
        "lspinfo",
        "trouble",
        "null-ls-info",
        "qf",
        "help",
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
    group = augroup("spell", { clear = true }),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Persistent Folds
local save_fold = augroup("Persistent Folds", { clear = true })
autocmd("BufWinLeave", {
    pattern = "*.*",
    callback = function()
        vim.cmd.mkview()
    end,
    group = save_fold,
})
autocmd("BufWinEnter", {
    pattern = "*.*",
    callback = function()
        vim.cmd.loadview({ mods = { emsg_silent = true } })
    end,
    group = save_fold,
})

-- Textfile spell
autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

--matchup custom
-- local matchup_words = "MatchUpWords"
-- augroup(matchup_words, { clear = true })
-- autocmd("FileType", {
--     group = matchup_words,
--     pattern = {"css", "javascript", "typescript", "cpp", "c"},
--     command = "call matchup#util#append_match_words('\/\*:\*\/')",
-- })

local enable_syntax = "SYNTAX_OMNIFUNC"
augroup(enable_syntax, { clear = true })
autocmd("FileType", {
    pattern = {
        "mako",
        "yaml.ansible",
        "applescript",
        "caddyfile",
        "csv",
        "glsl",
        "graphql",
        "haproxy",
        "helm",
        "mako",
        "nginx",
        "rst",
        "svg",
        "systemd",
        "xml",
        "log",
    },
    group = enable_syntax,
    callback = function()
        vim.opt_local.omnifunc = "syntaxcomplete#Complete"
    end,
})

local syntax = "SYNTAX"
augroup(syntax, { clear = true })
autocmd("FileType", {
    pattern = "*",
    command = [[:if !exists("g:syntax_on") | syntax on | endif]],
})

autocmd("BufWinEnter", {
    group = augroup("help_window_right", {}),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then
            vim.cmd.wincmd("L")
        end
    end,
})
