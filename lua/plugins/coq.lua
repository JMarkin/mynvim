local enabled = false

return {
    {
        "JMarkin/coq_nvim",
        dev = true,
        enabled = enabled,
        build = ":COQdeps",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "ms-jpq/coq.artifacts", branch = "artifacts" },
            { "ms-jpq/coq.thirdparty", branch = "3p" },
        },
        init = function()
            vim.g.loaded_python3_provider = 1
            if vim.env.PYTHON3 then
                vim.g.python3_host_prog = vim.env.PYTHON3
            end
            vim.g.coq_settings = { auto_start = true }
        end,
        config = function()
            require("coq_3p")({
                { src = "nvimlua", short_name = "nLUA" },
                { src = "vimtex", short_name = "vTEX" },
                { src = "builtin/ada" },
                { src = "builtin/c" },
                { src = "builtin/clojure" },
                { src = "builtin/css" },
                { src = "builtin/haskell" },
                { src = "builtin/html" },
                { src = "builtin/js" },
                { src = "builtin/php" },
                { src = "builtin/syntax" },
                { src = "builtin/xml" },
            })
        end,
    },
}
