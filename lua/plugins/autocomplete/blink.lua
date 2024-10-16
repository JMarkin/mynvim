return {
    "saghen/blink.cmp",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    -- optional: provides snippets for the snippet source
    dependencies = {
        "rafamadriz/friendly-snippets",
        "netmute/blink-cmp-ctags",
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',

    opts = {
        keymap = {
            show = "<C-space>",
            hide = "<C-e>",
            accept = "<cr>",
            select_prev = { "<Up>", "<C-p>", "<s-tab>" },
            select_next = { "<Down>", "<C-n>", "<tab>" },

            show_documentation = "<C-k>",
            hide_documentation = "<C-k>",
            scroll_documentation_up = "<C-e>",
            scroll_documentation_down = "<C-d>",

            snippet_forward = "<Tab>",
            snippet_backward = "<S-Tab>",
        },
        highlight = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = true,
        },
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        sources = {
            providers = {
                { "blink.cmp.sources.lsp", name = "LSP" },
                { "blink.cmp.sources.snippets", name = "Snippets", score_offset = -3 },
                { "blink.cmp.sources.buffer", name = "Buffer", fallback_for = { "LSP" } },
                { "blink-cmp-ctags", name = "Ctags", fallback_for = { "LSP" } },
            },
        },

        -- experimental auto-brackets support
        accept = { auto_brackets = { enabled = true } },
        -- experimental signature help support
        trigger = { signature_help = { enabled = true } },
    },
}
