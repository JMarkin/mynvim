return {
    "JMarkin/gen.nvim",
    dev = true,
    config = function()
        require("gen").setup({
            debug = false,
            model = "gemma:latest", -- The default model to use.
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
        })
        local Terminal = require("toggleterm.terminal").Terminal
        local oatmeal = Terminal:new({
            cmd = "oatmeal -e neovim --model gemma:latest",
            hidden = true,
            direction = "tab",
            on_open = function(term)
                vim.cmd("startinsert")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "n",
                    "<A-a>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "t",
                    "<A-a>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
            end,
        })
        local function oatmeal_toggle()
            oatmeal:toggle()
        end
        vim.keymap.set({ "n" }, "<A-a>", oatmeal_toggle, { desc = "Oatmeal", noremap = true, silent = true })
    end,
    cmd = "Gen",
    keys = {
        "<A-a>",
        {
            "<leader>]",
            function()
                require("ollama").toggle()
            end,
            mode = { "n", "v" },
            desc = "AI",
        },
    },
}
