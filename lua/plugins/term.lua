return {
    "akinsho/toggleterm.nvim",
    config = function()
        local toggleterm = require("toggleterm")

        toggleterm.setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<A-t>]],
            hide_numbers = true, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
            shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
            start_in_insert = true,
            insert_mappings = true, -- whether or not the open mapping applies in insert mode
            terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
            persist_size = false,
            persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
            direction = "horizontal",
            close_on_exit = true, -- close the terminal window when the process exits
            shell = vim.o.shell, -- change the default shell
            auto_scroll = false, -- automatically scroll to the bottom on terminal output
            float_opts = {
                border = "curved",
                winblend = 3,
            },
            winbar = {
                enabled = true,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end,
            },
            on_open = function(term)
                local opts = { buffer = 0 }
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
            end,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "n",
                    "<A-g>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "t",
                    "<A-g>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
            end,
        })

        local function lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set({ "n" }, "<A-g>", lazygit_toggle, { desc = "Git", noremap = true, silent = true })

        vim.api.nvim_create_user_command("Git", lazygit_toggle, { bang = true })

        local btop = Terminal:new({
            cmd = "btop",
            hidden = true,
            direction = "float",
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "n",
                    "<A-b>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
                vim.api.nvim_buf_set_keymap(
                    term.bufnr,
                    "t",
                    "<A-b>",
                    "<cmd>close<CR>",
                    { noremap = true, silent = true }
                )
            end,
        })

        local function btop_toggle()
            btop:toggle()
        end

        vim.keymap.set({ "n" }, "<A-b>", btop_toggle, { desc = "Btop", noremap = true, silent = true })
    end,
    cmd = { "Git" },
    keys = { "<A-g>", "<A-b>", "<A-t>", "<A-i>" },
}
