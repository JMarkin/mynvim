local modes = { "n", "o", "x" }
local keys = {
    { "w", "<cmd>lua require('spider').motion('w')<CR>", desc = "Spider-w", mode = modes },
    { "e", "<cmd>lua require('spider').motion('e')<CR>", desc = "Spider-e", mode = modes },
    { "b", "<cmd>lua require('spider').motion('b')<CR>", desc = "Spider-b", mode = modes },
    { "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge", mode = modes },
}
-- return {
--     "chrisgrieser/nvim-spider",
--     lazy = true,
--     enabled = false,
--     keys = keys,
-- }

return {
    "chaoren/vim-wordmotion"
}
