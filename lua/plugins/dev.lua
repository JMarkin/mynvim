-- for developments

return {
    {
        "vhyrro/luarocks.nvim",
        -- enabled = false,
        config = true,
        lazy = true,
        opts = {
            rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
        },
    },
    {
        "stevearc/profile.nvim",
        cond = function()
            return os.getenv("NVIM_PROFILE")
        end,
        lazy = true,
        config = function()
            local function toggle_profile()
                local prof = require("profile")
                if prof.is_recording() then
                    prof.stop()
                    vim.ui.input(
                        { prompt = "Save profile to:", completion = "file", default = "profile.json" },
                        function(filename)
                            if filename then
                                prof.export(filename)
                                vim.cmd([[profile stop]])
                                vim.notify(string.format("Wrote %s", filename))
                            end
                        end
                    )
                else
                    prof.start("*")
                end
            end
            vim.keymap.set("", "<F2>", toggle_profile)
        end,
    },
}
