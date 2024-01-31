return {
    "MattesGroeger/vim-bookmarks",
    enabled = false,
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
    keys = {
        {

            "<leader>ba",
            function()
                vim.cmd([[
                    cgetexpr bm#location_list()
                ]])
                require("fzf-lua").quickfix({})
            end,
            silent = true,
            desc = "Search: bookmarks",
        },
        -- stylua: ignore start
        { "<leader>bb",  "<Plug>BookmarkToggle",     desc = "Bookmark: Toggle"     },
        { "<leader>bi",  "<Plug>BookmarkAnnotate",   desc = "Bookmark: Annotate"   },
        { "]b",          "<Plug>BookmarkNext",       desc = "Bookmark: Next"       },
        { "[b",          "<Plug>BookmarkPrev",       desc = "Bookmark: Prev"       },
        { "<leader>bc",  "<Plug>BookmarkClear",      desc = "Bookmark: Clear"      },
        { "<leader>bx",  "<Plug>BookmarkClearAll",   desc = "Bookmark: ClearAll"   },
        { "<leader>bkk", "<Plug>BookmarkMoveUp",     desc = "Bookmark: MoveUp"     },
        { "<leader>bjj", "<Plug>BookmarkMoveDown",   desc = "Bookmark: MoveDown"   },
        { "<leader>bg",  "<Plug>BookmarkMoveToLine", desc = "Bookmark: MoveToLine" },
        -- stylua: ignore end
    },
}
