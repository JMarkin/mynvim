local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
function DiffviewToggle()
    local lib = require("diffview.lib")

    local view = lib.get_current_view()
    if view then
        vim.cmd(":DiffviewClose")
    else
        vim.cmd(":DiffviewOpen")
    end
end
local gr = augroup("DiffView", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = gr,
    pattern = "DiffviewViewEnter",
    callback = function()
        vim.cmd(":WindowsDisableAutowidth")
        vim.keymap.set("n", "q", DiffviewToggle, { silent = true })
    end,
})

vim.api.nvim_create_autocmd("User", {
    group = gr,
    pattern = "DiffviewViewLeave",
    callback = function()
        vim.cmd(":WindowsDisableAutowidth")
    end,
})

return {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
        { "<leader>gD", DiffviewToggle, silent = true, desc = "Git: Diffview toggle" },
        { "<leader>gF", ":DiffviewFileHistory %<cr>", silent = true, desc = "Git: DiffviewFileHistory current" },
    },
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
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
