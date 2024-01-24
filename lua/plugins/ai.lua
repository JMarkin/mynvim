local OLLAMA_URL = vim.env.OLLAMA_URL or "http://192.168.88.251:11434"

return {
    "David-Kunz/gen.nvim",
    opts = {
        model = "deepseek-coder:6.7b", -- The default model to use.
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the Prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        init = function(options)
            -- pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = "curl --silent --no-buffer -X POST " .. OLLAMA_URL .. "/api/generate -d $body",
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a lua function returning a command string, with options as the input parameter.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        list_models = "<omitted lua function>", -- Retrieves a list of model names
        debug = false, -- Prints errors and the command which is run.
    },
    config = function()
        require("gen").prompts["Doc"] = {
            prompt = "Write docstring for language $filetype for this $text, using google style",
            replace = false,
        }
        require("gen").prompts["WriteTest"] = {
            prompt = "Write test on different cases for language $filetype for this $text",
            replace = false,
            model = "phi:latest",
        }
        require("gen").prompts["Pytest"] = {
            prompt = "Write parametrize test on different cases for python using pytest for this $text",
            replace = false,
            model = "phi:latest",
        }
        require("gen").prompts["Postgresql"] = {
            prompt = "For postgresql generate query $text",
            replace = false,
        }

        local Terminal = require("toggleterm.terminal").Terminal
        local oatmeal = Terminal:new({
            cmd = "oatmeal -e neovim --model mistral:latest",
            hidden = true,
            direction = "float",
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
    keys = { "<A-a>", { "<leader>]", ":Gen<CR>", mode = { "n", "v" }, desc = "AI" } },
}
