local M = {}

M.plugin = {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen" },
    opts = {
        view = {
            -- Configure the layout and behavior of different types of views.
            -- Available layouts:
            --  'diff1_plain'
            --    |'diff2_horizontal'
            --    |'diff2_vertical'
            --    |'diff3_horizontal'
            --    |'diff3_vertical'
            --    |'diff3_mixed'
            --    |'diff4_mixed'
            -- For more info, see ':h diffview-config-view.x.layout'.
            default = {
                -- Config for changed files, and staged files in diff views.
                layout = "diff2_horizontal",
            },
            merge_tool = {
                -- Config for conflicted files in diff views during a merge or rebase.
                layout = "diff3_mixed",
                disable_diagnostics = true,
            },
            file_history = {
                -- Config for changed files in file history views.
                layout = "diff2_horizontal",
            },
        },
    },
}

return M
