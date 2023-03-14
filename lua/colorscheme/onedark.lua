require("onedarkpro").setup({
    filetypes = { -- Override which filetype highlight groups are loaded
        html = true,
        java = true,
        javascript = true,
        lua = true,
        markdown = true,
        php = true,
        python = true,
        ruby = true,
        rust = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        xml = true,
        yaml = true,
    },
    plugins = { -- Override which plugin highlight groups are loaded
        aerial = false,
        barbar = false,
        copilot = false,
        dashboard = true,
        gitsigns = true,
        hop = true,
        indentline = false,
        leap = true,
        lsp_saga = true,
        lsp_semantic_tokens = true,
        marks = true,
        neotest = true,
        neo_tree = false,
        nvim_cmp = true,
        nvim_bqf = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = false,
        nvim_lsp = true,
        nvim_navic = false,
        nvim_notify = true,
        nvim_tree = true,
        nvim_ts_rainbow = true,
        op_nvim = true,
        packer = false,
        polygot = false,
        startify = false,
        telescope = false,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        vim_ultest = true,
        which_key = true,
    },
    styles = { -- For example, to apply bold and italic, use "bold,italic"
        types = "NONE", -- Style that is applied to types
        methods = "NONE", -- Style that is applied to methods
        numbers = "NONE", -- Style that is applied to numbers
        strings = "NONE", -- Style that is applied to strings
        comments = "italic", -- Style that is applied to comments
        keywords = "bold,italic", -- Style that is applied to keywords
        constants = "bold", -- Style that is applied to constants
        functions = "NONE", -- Style that is applied to functions
        operators = "NONE", -- Style that is applied to operators
        variables = "NONE", -- Style that is applied to variables
        parameters = "italic", -- Style that is applied to parameters
        conditionals = "italic", -- Style that is applied to conditionals
        virtual_text = "undercurl", -- Style that is applied to virtual text
    },
    options = {
        cursorline = true, -- Use cursorline highlighting?
        transparency = true, -- Use a transparent background?
        terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
        highlight_inactive_windows = true, -- When the window is out of focus, change the normal background?
    },
})
vim.cmd("colorscheme onedark")
