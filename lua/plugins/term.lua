local toggleterm = require("toggleterm")

toggleterm.setup({
    -- size can be a number or function which is passed the current terminal
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
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    direction = "horizontal",
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    auto_scroll = false, -- automatically scroll to the bottom on terminal output
    -- This field is only relevant if direction is set to 'float'
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
})

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal

local gitui = Terminal:new({
    cmd = "gitui",
    hidden = true,
    direction = "float",
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<A-g>", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<A-g>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
})

local function gitui_toggle()
    gitui:toggle()
end

vim.keymap.set({ "n" }, "<A-g>", gitui_toggle, { desc = "Git", noremap = true, silent = true })

vim.api.nvim_create_user_command("Git", gitui_toggle, { bang = true })

local btop = Terminal:new({
    cmd = "btop",
    hidden = true,
    direction = "float",
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<A-b>", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<A-b>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
})

local function btop_toggle()
    btop:toggle()
end

vim.keymap.set({ "n" }, "<A-b>", btop_toggle, { desc = "Btop", noremap = true, silent = true })
