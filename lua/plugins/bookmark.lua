local M = {}

M.plugin = {
    "MattesGroeger/vim-bookmarks",
    dependencies = { "ibhagwan/fzf-lua" },
    init = function()
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
    end,
    keys = "<leader>b",
}
M.search = function()
    vim.cmd([[
        cgetexpr bm#location_list()
    ]])
    require("fzf-lua").quickfix({})
end

M.keymaps = function()
    vim.keymap.set("n", "<leader>bb", "<Plug>BookmarkToggle", { desc = "Bookmark: Toggle" })
    vim.keymap.set("n", "<leader>bi", "<Plug>BookmarkAnnotate", { desc = "Bookmark: Annotate" })
    vim.keymap.set("n", "<leader>ba", M.search, { desc = "Bookmark: ShowAll" })
    vim.keymap.set("n", "<leader>bj", "<Plug>BookmarkNext", { desc = "Bookmark: Next" })
    vim.keymap.set("n", "<leader>bk", "<Plug>BookmarkPrev", { desc = "Bookmark: Prev" })
    vim.keymap.set("n", "<leader>bc", "<Plug>BookmarkClear", { desc = "Bookmark: Clear" })
    vim.keymap.set("n", "<leader>bx", "<Plug>BookmarkClearAll", { desc = "Bookmark: ClearAll" })
    vim.keymap.set("n", "<leader>bkk", "<Plug>BookmarkMoveUp", { desc = "Bookmark: MoveUp" })
    vim.keymap.set("n", "<leader>bjj", "<Plug>BookmarkMoveDown", { desc = "Bookmark: MoveDown" })
    vim.keymap.set("n", "<leader>bg", "<Plug>BookmarkMoveToLine", { desc = "Bookmark: MoveToLine" })
end

return M
