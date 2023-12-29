return {
    "backdround/neowords.nvim",
    lazy = true,
    enabled = true,
    keys = {
        "w",
        "e",
        "b",
        "ge",
    },
    config = function()
        local neowords = require("neowords")
        -- local p = neowords.pattern_presets

        local p = {
            snake_case = "\\v[[:lower:]]+",
            camel_case = "\\v[[:upper:]][[:lower:]]+",
            upper_case = "\\v[[:upper:]]+[[:lower:]]@!",
            number = "\\v[[:digit:]]+",
            hex_color = "\\v#[[:xdigit:]]+",

            any_word = "\\v-@![-_[:lower:][:upper:]]+",
        }

        local subword_hops =
            neowords.get_word_hops(p.sneak_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v#+", "\\v[<>]+")

        vim.keymap.set({ "n", "x", "o" }, "w", subword_hops.forward_start)
        vim.keymap.set({ "n", "x", "o" }, "e", subword_hops.forward_end)
        vim.keymap.set({ "n", "x", "o" }, "b", subword_hops.backward_start)
        vim.keymap.set({ "n", "x", "o" }, "ge", subword_hops.backward_end)
    end,
}
