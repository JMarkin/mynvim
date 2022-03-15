require("nvim-treesitter.configs").setup({
    ensure_installed = "maintained",
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = false,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 500, -- Do not enable for files with more than n lines, int
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})

local present, ts_context = pcall(require, "treesitter-context")
if present then
    ts_context.setup()
end

local present, ts_atag = pcall(require, "nvim-ts-autotag")
if present then
    ts_atag.setup()
end
