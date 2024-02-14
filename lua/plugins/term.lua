function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

return {
    {
        "akinsho/toggleterm.nvim",
        lazy = true,
        config = function()
            local toggleterm = require("toggleterm")

            local shell = vim.o.shell

            if vim.fn.executable("fish") then
                shell = "fish"
            end

            toggleterm.setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                open_mapping = [[<A-t>]],
                hide_numbers = true,
                shade_filetypes = {},
                autochdir = false,
                shade_terminals = true,
                start_in_insert = false,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = false,
                persist_mode = true,
                direction = "horizontal",
                close_on_exit = true,
                shell = shell,
                auto_scroll = false,
                float_opts = {
                    border = "curved",
                    winblend = 3,
                },
                winbar = {
                    enabled = true,
                    name_formatter = function(term)
                        return term.name
                    end,
                },
                on_open = function(term)
                    local opts = { buffer = term.bufnr }
                    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
                end,
            })

            -- local Terminal = require("toggleterm.terminal").Terminal

            -- local lazygit = Terminal:new({
            --     cmd = "lazygit",
            --     hidden = true,
            --     direction = "float",
            --     on_open = function(term)
            --         vim.cmd("startinsert!")
            --         vim.api.nvim_buf_set_keymap(
            --             term.bufnr,
            --             "n",
            --             "q",
            --             "<cmd>close<CR>",
            --             { noremap = true, silent = true }
            --         )
            --         vim.api.nvim_buf_set_keymap(
            --             term.bufnr,
            --             "n",
            --             "<A-g>",
            --             "<cmd>close<CR>",
            --             { noremap = true, silent = true }
            --         )
            --         vim.api.nvim_buf_set_keymap(
            --             term.bufnr,
            --             "t",
            --             "<A-g>",
            --             "<cmd>close<CR>",
            --             { noremap = true, silent = true }
            --         )
            --
            --         vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
            --     end,
            -- })
            --
            -- local function lazygit_toggle()
            --     lazygit:toggle()
            -- end
            --
            -- vim.keymap.set({ "n" }, "<A-g>", lazygit_toggle, { desc = "Git", noremap = true, silent = true })
            --
            -- vim.api.nvim_create_user_command("Git", lazygit_toggle, { bang = true })
        end,
        keys = { "<A-g>", "<A-t>" },
    },
    {
        "willothy/flatten.nvim",
        enabled = true,
        config = true,
        opts = {
            window = {
                open = "tab",
            },
        },
        lazy = false,
        priority = 1001,
    },
}
