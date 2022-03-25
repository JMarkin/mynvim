local M = {}

M.setup = function()
    vim.g.bookmark_highlight_lines = 1
    vim.g.bookmark_save_per_working_dir = 1
    vim.g.bookmark_auto_save = 1
    vim.g.bookmark_manage_per_buffer = 1
    vim.g.bookmark_no_default_key_mappings = 1

    vim.cmd([[
        function! g:BMWorkDirFileLocation()
            let filename = 'bookmarks'
            let location = ''
            if isdirectory('.git')
                " Current work dir is git's work tree
                let location = getcwd().'/.git'
            else
                " Look upwards (at parents) for a directory named '.git'
                let location = finddir('.git', '.;')
            endif
            if len(location) > 0
                return location.'/'.filename
            else
                return getcwd().'/.'.filename
            endif
        endfunction

        function! g:BMBufferFileLocation(file)
            let filename = 'vim-bookmarks'
            let location = ''
            if isdirectory(fnamemodify(a:file, ":p:h").'/.git')
                " Current work dir is git's work tree
                let location = fnamemodify(a:file, ":p:h").'/.git'
            else
                " Look upwards (at parents) for a directory named '.git'
                let location = finddir('.git', fnamemodify(a:file, ":p:h").'/.;')
            endif
            if len(location) > 0
                return simplify(location.'/.'.filename)
            else
                return simplify(fnamemodify(a:file, ":p:h").'/.'.filename)
            endif
        endfunction
    ]])
end

M.config = function()
    local m = require("mapx")

    m.nname("<leader>b", "Bookmark")

    nnoremap("<leader>bb", "<Plug>BookmarkToggle", "Bookmark: Toggle")
    nnoremap("<leader>bi", "<Plug>BookmarkAnnotate", "Bookmark: Annotate")
    nnoremap("<leader>ba", "<Plug>BookmarkShowAll", "Bookmark: ShowAll")
    nnoremap("<leader>bj", "<Plug>BookmarkNext", "Bookmark: Next")
    nnoremap("<leader>bk", "<Plug>BookmarkPrev", "Bookmark: Prev")
    nnoremap("<leader>bc", "<Plug>BookmarkClear", "Bookmark: Clear")
    nnoremap("<leader>bx", "<Plug>BookmarkClearAll", "Bookmark: ClearAll")
    nnoremap("<leader>bkk", "<Plug>BookmarkMoveUp", "Bookmark: MoveUp")
    nnoremap("<leader>bjj", "<Plug>BookmarkMoveDown", "Bookmark: MoveDown")
    nnoremap("<leader>bg", "<Plug>BookmarkMoveToLine", "Bookmark: MoveToLine")
end

return M
