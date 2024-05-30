return {
    "prichrd/netrw.nvim",
    config = function()
        require("netrw").setup({
            icons = {
                symlink = "", -- Symlink icon (directory and file)
                directory = "", -- Directory icon
                file = "", -- File icon
            },
            use_devicons = true,
            mappings = {
                -- Function mappings
                ["p"] = function(payload)
                    -- Payload is an object describing the node under the cursor, the object
                    -- has the following keys:
                    -- - dir: the current netrw directory (vim.b.netrw_curdir)
                    -- - node: the name of the file or directory under the cursor
                    -- - link: the referenced file if the node under the cursor is a symlink
                    -- - extension: the file extension if the node under the cursor is a file
                    -- - type: the type of node under the cursor (0 = dir, 1 = file, 2 = symlink)
                    -- - col: the column of the node (for liststyle 3)
                    print(vim.inspect(payload))
                end,
                -- String command mappings
                ["<Leader><Tab>"] = ":echo 'string command'<CR>",
                -- more mappings ...
            },
        })
    end,
}
