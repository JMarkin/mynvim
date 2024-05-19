return {
    { "echasnovski/mini.pairs", enabled = false, event = { "InsertEnter", "CmdwinEnter" }, opts = {} },
    {
        "ZhiyuanLck/smart-pairs",
        event = "InsertEnter",
        config = function()
            require("pairs"):setup()
        end,
    },
}
