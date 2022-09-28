local M = {}

local callbacks = {}

M.callback_after_setup = function(call)
    table.insert(callbacks, call)
end

M.setup = function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "c",
            "lua",
            "rust",
            "cpp",
            "cuda",
            "python",
            -- "vim",
            "typescript",
            "javascript",
            "yaml",
            "toml",
            "make",
            "fish",
            "go",
            "html",
            "css",
            "bash",
            "dockerfile",
            "vue",
            "scss",
        },
        indent = {
            enable = false,
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 1500, -- Do not enable for files with more than n lines, int
        },
        incremental_selection = {
            enable = false,
            keymaps = {
                init_selection = "gi",
                node_incremental = "gnn",
                scope_incremental = "gss",
                node_decremental = "gnd",
            },
        },
        yati = { enable = true },
        matchup = {
            enable = false,
        },
    })

    for _, call in ipairs(callbacks) do
        call()
    end
end

return M
