local M = {}

M.plugin = {
    "HampusHauffman/block.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
        require("block").setup({
            automatic = false,
        })
    end,
    cmd = { "Block", "BlockOn", "BlockOff" },
    event = { "BufReadPost", "FileReadPost" },
}

return M
