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

local present_hlargs, ts_hlargs = pcall(require, "hlargs")
if present_hlargs then
    ts_hlargs.setup()
end

local present_ctx, ts_context = pcall(require, "treesitter-context")
if present_ctx then
    ts_context.setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true,
    })
end

local present_atag, ts_atag = pcall(require, "nvim-ts-autotag")
if present_atag then
    ts_atag.setup()
end
