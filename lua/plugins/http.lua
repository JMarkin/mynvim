local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
    group = augroup("http", { clear = true }),
    pattern = {
        "http",
    },
    callback = function(event)
        vim.keymap.set(
            "n",
            "<leader>hr",
            "<Plug>RestNvim",
            { buffer = event.buf, silent = true, desc = "run the request under the cursor" }
        )
        vim.keymap.set(
            "n",
            "<leader>hp",
            "<Plug>RestNvimPreview",
            { buffer = event.buf, silent = true, desc = "preview the request cURL command" }
        )
        vim.keymap.set(
            "n",
            "<leader>hl",
            "<Plug>RestNvimLast",
            { buffer = event.buf, silent = true, desc = "re-run the last request" }
        )
    end,
})

return {
    "rest-nvim/rest.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    ft = "http",
    keys = {
        "<leader>hr",
        "<leader>hp",
        "<leader>hl",
    },
    opts = {
        -- Open request results in a horizontal split
        result_split_horizontal = true,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = true,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
            enabled = true,
            timeout = 150,
        },
        result = {
            -- toggle showing URL, HTTP info, headers at top the of result window
            show_url = true,
            -- show the generated curl command in case you want to launch
            -- the same request via the terminal (can be verbose)
            show_curl_command = true,
            show_http_info = true,
            show_headers = true,
            -- table of curl `--write-out` variables or false if disabled
            -- for more granular control see Statistics Spec
            show_statistics = false,
            -- executables or functions for formatting response body [optional]
            -- set them to false if you want to disable them
            formatters = {
                json = "jq",
                html = function(body)
                    return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
                end,
            },
        },
        -- Jump to request line on run
        jump_to_request = true,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
    },
}
