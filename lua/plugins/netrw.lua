vim.g.netrw_list_hide = [[.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git]]
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15
vim.netrw_keepdir = 0

require("netrw").setup({
    use_devicons = true,
    mappings = {
        ["a"] = function(_)
            local action_create = function(fname)
                if not fname then
                    return
                end
                -- Netrw sets a buffer variable for the current dir. We can
                -- concatenate that path with the provided file name.
                local new_fpath = vim.b.netrw_curdir .. "/" .. fname

                -- We create the file using vim.loop. For more info, see `:h uv`
                local ok, fd = pcall(vim.loop.fs_open, new_fpath, "w", 420)
                if not ok then
                    vim.notify("error creating file", vim.log.levels.ERROR)
                    return
                end
                vim.loop.fs_close(fd)

                -- Netrw binds <C-l> (refresh) to the following function call.
                vim.cmd('execute "normal <c-l>"')
            end

            -- Create a prompt (see `:h vim.ui.input` for more options)
            vim.ui.input({ prompt = "Enter filename: " }, action_create)
        end,
    },
})
