return {
    "Asheq/close-buffers.vim",
    event = { "BufAdd", "BufReadPost", "FileReadPost" },
    keys = {
        {
            "<space>bd",
            "<cmd>Bdelete this<Cr>",
            desc = "Buffer: delete current",
        },
        {
            "<space>bc",
            "<cmd>Bdelete other<Cr>",
            desc = "Buffer: delete other",
        },
    },
}
