local is_not_mini = require("funcs").is_not_mini

return {
    "kristijanhusak/vim-dadbod-ui",
    enabled = true,
    cond = is_not_mini,
    dependencies = {
        "tpope/vim-dadbod",
        {
            "kristijanhusak/vim-dadbod-completion",
            dependencies = "nvim-cmp",
        },
    },
    init = function()
        vim.g.db_ui_execute_on_save = 0
        vim.g.db_ui_win_position = "right"
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_use_nerd_fonts = 1
    end,
    ft = { "sql", "mssql", "plsql" },
    cmd = { "DB", "DBUI" },
}
