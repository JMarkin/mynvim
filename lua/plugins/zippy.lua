require("zippy").setup({
    ["lua"] = {
        print_function = "print",
    },
    ["typescriptreact"] = {
        print_function = "console.debug",
    },
    ["python"] = {
        print_function = "print",
        language_format_behaviour = "none",
    },
})
