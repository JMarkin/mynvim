local M = {}

M.setup = function()
    vim.g.minimap_auto_start_win_enter = 0
    vim.g.minimap_auto_start = 0
    vim.g.minimap_highlight_search = 1
    vim.g.minimap_highlight_range = 1
    vim.g.minimap_git_colors = 1
    vim.g.minimap_block_filetypes = { "NvimTree", "Trouble", "Vista", "help" }
end

M.config = function()
    vim.cmd([[
        function! FloatWindowMinimapHack() abort
            let mmwinnr = bufwinnr('-MINIMAP-')
            if mmwinnr == -1
                return
            endif
            if winnr() == mmwinnr
                " Go to the other window
                execute 'wincmd t'
            endif
        endfunction
        autocmd WinEnter <buffer> call FloatWindowMinimapHack()
    ]])
end

return M
