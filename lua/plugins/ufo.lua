local M = {}

local is_not_mini = require("custom.funcs").is_not_mini

local ftMap = {
    vim = "treesitter",
    python = "indent",
}

local function customizeSelector(bufnr)
    local function handleFallbackException(err, providerName)
        if type(err) == "string" and err:match("UfoFallbackException") then
            return require("ufo").getFolds(bufnr, providerName)
        else
            return require("promise").reject(err)
        end
    end

    return require("ufo")
        .getFolds(bufnr, "lsp")
        :catch(function(err)
            return handleFallbackException(err, "treesitter")
        end)
        :catch(function(err)
            return handleFallbackException(err, "indent")
        end)
end

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ("  %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

M.plugin = {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    cond = is_not_mini,
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter" },
    event = "BufReadPost",
    opts = {
        fold_virt_text_handler = handler,
        provider_selector = function(_, filetype, _)
            return ftMap[filetype] or customizeSelector
        end,
        open_fold_hl_timeout = 400,
        close_fold_kinds = { "imports", "comment" },
        preview = {
            win_config = {
                border = { "", "─", "", "", "", "─", "", "" },
                -- winhighlight = "Normal:Folded",
                winblend = 0,
            },
            mappings = {
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                jumpTop = "[",
                jumpBot = "]",
            },
        },
    },
    init = function()
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        vim.o.foldcolumn = "1" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            desc = "Open All Folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
            desc = "Close All Folds",
        },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds()
            end,
            desc = "Close All Folds",
        },
        {
            "zK",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    local ok, _ = pcall(require, "lspsaga")
                    if ok then
                        vim.cmd([[ Lspsaga hover_doc ]])
                    else
                        vim.lsp.buf.hover()
                    end
                end
            end,
            desc = "Hover doc",
        },
    },
}

return M
