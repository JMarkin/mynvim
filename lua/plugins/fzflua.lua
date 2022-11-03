local M = {}

M.setup = function()
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
        },
    })
    require('fzf-lua').config.globals.fzf_opts['--border'] = nil
end

M.search_old_files = function()
    require("fzf-lua").oldfiles({
        multiprocess = true,
        cwd_only = function()
            return vim.api.nvim_command("pwd") ~= vim.env.HOME
        end,
    })
end

return M
