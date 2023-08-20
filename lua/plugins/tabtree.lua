return {
    "roobert/tabtree.nvim",
    dependencies = { "nvim-treesitter" },
    event = { "BufReadPost", "FileReadPost" },
    config = function()
        require("tabtree").setup({
            -- print the capture group name when executing next/previous
            --debug = true,

            -- disable key bindings
            --key_bindings_disabled = true,

            key_bindings = {
                next = "<Tab>",
                previous = "<S-Tab>",
            },

            -- use TSPlaygroundToggle to discover the (capture group)
            -- @capture_name can be anything
            language_configs = {
                python = {
                    target_query = [[
                      (identifier) @identifier_capture
                      (string) @string_capture
                      (interpolation) @interpolation_capture
                      (parameters) @parameters_capture
                      (argument_list) @argument_list_capture
                    ]],
                    offsets = {
                        string_start_capture = 1,
                    },
                },
                lua = {
                    target_query = [[
                      (identifier) @identifier_capture
                      (string_content) @string_content_capture
                      (parameters) @parameters_capture
                      (table_constructor) @table_constructor_capture
                    ]],
                    offsets = {
                        string_start_capture = 1,
                    },
                },
            },

            default_config = {
                target_query = [[
              (identifier) @identifier_capture
              (string) @string_capture
              (parameters) @parameters_capture
          ]],
                offsets = {},
            },
        })
    end,
}
