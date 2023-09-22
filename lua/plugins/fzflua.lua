local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    lazy = true,
    dependencies = {
        {
            "lotabout/skim",
            build = "cargo install skim",
        },
    },
    keys = {
        {
            "<leader>sq",
            function()
                require("fzf-lua").quickfix({ multiprocess = true })
            end,
            desc = "Search: quickfix",
        },
        {
            "<leader>sr",
            function()
                require("fzf-lua").oldfiles({
                    multiprocess = true,
                    cwd_only = true,
                })
            end,
            desc = "Search: old files",
        },
        {
            "<leader>sl",
            function()
                require("fzf-lua").loclist({ multiprocess = true })
            end,
            desc = "Search: loclist",
        },
        {
            "<leader>ss",
            function()
                require("fzf-lua").resume({ multiprocess = true })
            end,
            desc = "Search: previous",
        },
        -- {
        --     "<leader>sb",
        --     function()
        --         require("fzf-lua").buffers({ multiprocess = true, current_tab_only = true })
        --     end,
        --     desc = "Search: buffers",
        -- },
        {
            "<leader>sb",
            function()
                require("fzf-lua").buffers({ multiprocess = true }) --, current_tab_only = true })
            end,
            desc = "Search: buffers",
        },
        {
            "<leader>sf",
            function()
                require("fzf-lua").files({ multiprocess = true })
            end,
            desc = "Search: find files",
        },
        {
            "<leader>sg",
            function()
                require("fzf-lua").grep_project({ multiprocess = true, continue_last_search = true })
            end,
            desc = "Search: project",
        },
        {
            "<leader>sg",
            function()
                require("fzf-lua").grep_visual({ multiprocess = true, continue_last_search = true })
            end,
            desc = "Search: project",
            mode = "v",
        },
        {
            "<leader>s/",
            function()
                require("fzf-lua").lgrep_curbuf({ multiprocess = true })
            end,
            desc = "Search: current buffer",
        },
        {
            "<leader>st",
            function()
                require("fzf-lua").tags_live_grep({ multiprocess = true })
            end,
            desc = "Search: tags",
        },
        {
            "<leader>st",
            function()
                require("fzf-lua").tags_grep_visual({ multiprocess = true })
            end,
            desc = "Search: tags",
            mode = "v",
        },
        {
            "<leader>sd",
            function()
                require("fzf-lua").lsp_definitions({ multiprocess = true })
            end,
            desc = "Search: Definitions",
        },
        {
            "<leader>sS",
            function()
                require("fzf-lua").lsp_live_workspace_symbols({ multiprocess = true })
            end,
            desc = "Search: Symbols",
        },
        {
            "<leader>sc",
            function()
                require("fzf-lua").commands({ multiprocess = true })
            end,
            desc = "Search: commands",
        },
        {
            "<leader>sk",
            function()
                require("fzf-lua").keymaps({ multiprocess = true })
            end,
            desc = "Search: keymaps",
        },
        {
            "<leader>sch",
            function()
                require("fzf-lua").command_history({ multiprocess = true })
            end,
            desc = "Search: command_history",
        },
        {
            "<leader>sG",
            function()
                require("fzf-lua").git_status({ multiprocess = true })
            end,
            desc = "Search: git status",
        },
        {
            "gr",
            function()
                require("fzf-lua").lsp_finder({ multiprocess = true, ignore_current_line = true })
            end,
            silent = true,
            desc = "GoTo: references",
        },
    },
    config = function()
        require("fzf-lua").setup({
            fzf_bin = "sk",
            async_or_timeout = 3000,
            global_resume = true,
            global_resume_query = true,
            winopts = {
                width = 0.9,
                preview = {
                    default = "builtin",
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

        local fzf = "FZF"
        augroup(fzf, { clear = true })
        autocmd("VimResized", {
            pattern = "*",
            group = fzf,
            command = 'lua require("fzf-lua").redraw()',
        })
    end,
}
