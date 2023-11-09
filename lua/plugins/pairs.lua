return {
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6", --recomended as each new version will have breaking changes
        opts = {
            --Config goes here
        },
        enabled = true,
    },
    { "echasnovski/mini.pairs", enabled = false, event = "InsertEnter", opts = {} },
}
