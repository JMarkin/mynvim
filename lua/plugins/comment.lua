local _keys = { "gcc", "gc" }
local keys = {}

for k, v in pairs(_keys) do
    keys[k] = { v, mode = { "n", "v" } }
end

return {
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "echasnovski/mini.comment",
        event = "ModeChanged",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },
}
