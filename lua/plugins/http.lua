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
            "<cmd>Rest run<cr>",
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
            "<cmd>Rest run last<cr>",
            { buffer = event.buf, silent = true, desc = "re-run the last request" }
        )
    end,
})

return {
    "rest-nvim/rest.nvim",
    dependencies = { "luarocks.nvim" },
    ft = "http",
    keys = {
        "<leader>hr",
        "<leader>hp",
        "<leader>hl",
    },
    config = function()
        require("rest-nvim").setup({
            logs = {
                level = "warn",
                save = true,
            },
            result = {
                split = {
                    horizontal = true,
                    in_place = false,
                    stay_in_current_window_after_split = true,
                },
                behavior = {
                    statistics = {
                        enable = true,
                        ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
                        stats = {
                            { "total_time", title = "Time total:" },
                            { "namelookup_time", title = "Time dns:" },
                            { "appconnect_time", title = "Time app connect:" },
                            { "pretransfer_time", title = "Time pre transfer:" },
                            -- { "redirect_time", title = "Time redirect:" },
                            { "starttransfer_time", title = "Time start transfer:" },
                            { "size_download_t", title = "Download size:" },
                            { "speed_download_t", title = "Download speed:" },
                            { "speed_upload_t", title = "Upload speed:" },
                        },
                    },
                    formatters = {
                        json = "jaq",
                        html = "prettier",
                        -- plain = "prettier",
                    },
                },
            },
        })
    end,
}
