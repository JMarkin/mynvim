-- for developments

return {
    {
        "theHamsta/nvim_rocks",
        enabled = true,
        lazy = true,
        build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    },
    {
        "stevearc/profile.nvim",
        keys = "F2",
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
