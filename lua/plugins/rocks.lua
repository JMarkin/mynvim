return {
    "theHamsta/nvim_rocks",
    lazy = true,
    build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    config = function()
        local rocks = require("nvim_rocks")
        rocks.ensure_installed("luautf8")
    end,
}
