return {
    {
        "David-Kunz/gen.nvim",
        config = function()
            require("gen").setup({
                debug = false,
                model = "phi3:14b-medium-128k-instruct-q4_1", -- The default model to use.
                display_mode = "split", -- The display mode. Can be "float" or "split".
                show_prompt = true, -- Shows the Prompt submitted to Ollama.
                show_model = true, -- Displays which model you are using at the beginning of your chat session.
                no_auto_close = false, -- Never closes the window automatically.
                init = function(options)
                    -- pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
                end,
                host = vim.env.OLLAMA_HOST or "192.168.88.251",
                port = vim.env.OLLAMA_PORt or "11434",
                reprompt = {
                    enabled = true,
                    clear = false,
                    focus_on_new = true,
                    map = "<c-r>",
                },
                quit_map = "q", -- set keymap for close the response window
                retry_map = "<c-r>", -- set keymap to re-send the current prompt
            })
        end,
        cmd = "Gen",
    },
    -- {
    --     "TabbyML/vim-tabby",
    --     init = function()
    --         vim.g.tabby_trigger_mode = "manual"
    --         vim.g.tabby_keybinding_accept = "<tab>"
    --         vim.g.tabby_keybinding_trigger_or_dismiss = "<C-\\>"
    --     end,
    -- },
}
