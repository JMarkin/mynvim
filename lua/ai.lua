vim.keymap.set("n", "<leader>]", function()
    require("ollama").toggle()
end, { desc = "AI" })
vim.keymap.set("v", "<leader>]", function()
    require("ollama").toggle()
end, { desc = "AI" })

local lsp_ai_config = {
    -- Uncomment if using nvim-cmp
    -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
    cmd = { "lsp-ai" },
    root_dir = vim.loop.cwd(),
    init_options = {
        memory = {
            file_store = {},
        },
        models = {
            deepcoder = {
                type = "ollama",
                model = "wojtek/deepseek-coder:7b-instruct-v1.5-q4_k",
                generate_endpoint = vim.g.ollama_generate_endpoint,
                chat_endpoint = vim.g.ollama_chat_endpoint,
            },
        },
        completion = {
            model = "deepcoder",
            parameters = {
                fim = {
                    start = "<|fim_prefix|>",
                    middle = "<|fim_suffix|>",
                    ["end"] = "<|fim_middle|>",
                },
                max_context = 2000,
                max_new_tokens = 32,
            },
        },
    },
}

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--     callback = function()
--         vim.lsp.start(lsp_ai_config)
--     end,
-- })

-- Register key shortcut
-- vim.keymap.set("n", "<leader>co", function()
--     vim.lsp.start(lsp_ai_config)
--     print("Loading completion...")
--
--     local x = vim.lsp.util.make_position_params(0)
--     local y = vim.lsp.util.make_text_document_params(0)
--
--     local combined = vim.tbl_extend("force", x, y)
--
--     local result = vim.lsp.buf_request_sync(0, "textDocument/completion", combined, 10000)
--
--     print(vim.inspect(result))
--     vim.lsp.st(lsp_ai_config)
-- end, {
--     noremap = true,
--     desc = "AI completion",
-- })
