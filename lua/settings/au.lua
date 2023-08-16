local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- синхронизация между инстансами
local sync_neovim = "SHADA"
augroup(sync_neovim, { clear = true })

autocmd({ "TextYankPost" }, {
    group = sync_neovim,
    pattern = { "*" },
    callback = function()
        vim.cmd([[if exists(':rshada /tmp/shada') | rshada /tmp/shada | wshada /tmp/shada | endif]])
    end,
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
    },
    callback = function(event)
        vim.opt_local.wrap = false
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
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
        local file = vim.loop.fs_realpath(event.match) or event.match
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

local fzf = "FZF"
augroup(fzf, { clear = true })
autocmd("VimResized", {
    pattern = "*",
    group = fzf,
    command = 'lua require("fzf-lua").redraw()',
})

local enable_syntax = "ENABLE_SYNTAX"
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
        vim.opt.omnifunc = "syntaxcomplete#Complete"
    end,
})

local syntax = "SYNTAX"
augroup(syntax, { clear = true })
autocmd("FileType", {
    pattern = "*",
    command = [[:if !exists("g:syntax_on") | syntax on | endif]],
})
