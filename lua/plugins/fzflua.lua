require("fzf-lua").setup({
    fzf_bin = "sk",
    async_or_timeout = 3000,
    global_resume = true,
    global_resume_query = true,
    winopts = {
        width = 0.9,
        preview = {
            default = "bat",
            layout = "vertical",
            title_align = "center",
        },
    },
    keymap = {
        fzf = {
            ["ctrl-a"] = "abort",
            ["ctrl-b"] = "beginning-of-line",
        },
    },
    fzf_opts = {
        ["--ansi"] = "",
        ["--info"] = "inline",
        ["--height"] = "100%",
        ["--layout"] = "reverse",
        ["--no-separator"] = false,
    },
    files = {
        rg_opts = "--color=never --files --no-ignore --hidden -g '!.git'",
        fd_opts = "--color=never --type f --no-ignore --hidden --exclude .git",
    },
})
require("fzf-lua").config.globals.fzf_opts["--border"] = nil

vim.keymap.set("n", "<leader>sq", function()
    require("fzf-lua").quickfix({ multiprocess = true })
end, { desc = "Search: quickfix" })

vim.keymap.set("n", "<leader>sr", function()
    require("fzf-lua").oldfiles({
        multiprocess = true,
        cwd_only = true,
    })
end, { desc = "Search: old files" })

vim.keymap.set("n", "<leader>sl", function()
    require("fzf-lua").loclist({ multiprocess = true })
end, { desc = "Search: loclist" })

vim.keymap.set("n", "<leader>ss", function()
    require("fzf-lua").resume({ multiprocess = true })
end, { desc = "Search: previous" })

vim.keymap.set("n", "<leader>sb", function()
    require("fzf-lua").buffers({ multiprocess = true, current_tab_only = true })
end, { desc = "Search: buffers" })

vim.keymap.set("n", "<leader>sf", function()
    require("fzf-lua").files({ multiprocess = true })
end, { desc = "Search: find files" })

vim.keymap.set("n", "<leader>sg", function()
    require("fzf-lua").grep_project({ multiprocess = true, continue_last_search = true })
end, { desc = "Search: project" })

vim.keymap.set("v", "<leader>sg", function()
    require("fzf-lua").grep_visual({ multiprocess = true, continue_last_search = true })
end, { desc = "Search: project" })

vim.keymap.set("n", "<leader>s/", function()
    require("fzf-lua").lgrep_curbuf({ multiprocess = true })
end, { desc = "Search: current buffer" })

vim.keymap.set("n", "<leader>st", function()
    require("fzf-lua").tags_live_grep({ multiprocess = true })
end, { desc = "Search: tags" })
vim.keymap.set("v", "<leader>st", function()
    require("fzf-lua").tags_grep_visual({ multiprocess = true })
end, { desc = "Search: tags" })

vim.keymap.set("n", "<leader>sd", function()
    require("fzf-lua").lsp_definitions({ multiprocess = true })
end, { desc = "Search: Definitions" })

vim.keymap.set("n", "<leader>sS", function()
    require("fzf-lua").lsp_live_workspace_symbols({ multiprocess = true })
end, { desc = "Search: Symbols" })

vim.keymap.set("n", "<leader>sc", function()
    require("fzf-lua").commands({ multiprocess = true })
end, { desc = "Search: commands" })

vim.keymap.set("n", "<leader>sk", function()
    require("fzf-lua").keymaps({ multiprocess = true })
end, { desc = "Search: keymaps" })

vim.keymap.set("n", "<leader>sch", function()
    require("fzf-lua").command_history({ multiprocess = true })
end, { desc = "Search: command_history" })

vim.keymap.set("n", "gr", function()
    require("fzf-lua").lsp_finder({ multiprocess = true, ignore_current_line = true })
end, { silent = true, desc = "GoTo: references" })

vim.keymap.set("n", "<leader>sP", require("plugins.project").search, { silent = true, desc = "Search: project" })
vim.keymap.set("n", "<leader>sB", require("plugins.bookmark").search, { silent = true, desc = "Search: bookmarks" })
