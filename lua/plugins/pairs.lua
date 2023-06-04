local M = {}

M.plugin = {
    "altermo/npairs-integrate-upair",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "windwp/nvim-autopairs",
        "altermo/ultimate-autopair.nvim",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("npairs-int-upair").setup({ map = "u" })
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        ---@diagnostic disable-next-line: different-requires
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}

return M
