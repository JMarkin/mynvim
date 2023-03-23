return function(colors)
    return {
        Error = { fg = colors.red_dark, bold = true, style = "bold" },
        ErrorMsg = { fg = colors.red, bold = true, style = "bold" },
        ModeMsg = { fg = colors.yellow },
        Question = { fg = colors.orange_light, underline = true, style = "underline" },
        Todo = { fg = colors.cyan, bold = true, style = "bold" },
        WarningMsg = { fg = colors.orange, bold = true, style = "bold" },

        FoldColumn = { fg = colors.gray_darker, bold = true },
        Folded = { fg = colors.purple_light, italic = true },

        DiffAdd = { fg = colors.green_dark },
        diffAdded = { link = "DiffAdd" },
        DiffChange = {},
        DiffDelete = { fg = colors.red },
        DiffText = { fg = colors.yellow },
        diffRemoved = { link = "DiffDelete" },

        DiagnosticError = { link = "Error" },
        DiagnosticFloatingError = { link = "ErrorMsg" },
        DiagnosticSignError = { link = "DiagnosticFloatingError" },

        DiagnosticWarn = { fg = colors.orange, bold = true, style = "bold" },
        DiagnosticFloatingWarn = { link = "WarningMsg" },
        DiagnosticSignWarn = { link = "DiagnosticFloatingWarn" },

        DiagnosticHint = { fg = colors.magenta, bold = true, style = "bold" },
        DiagnosticFloatingHint = { fg = colors.magenta, italic = true, style = "bold" },
        DiagnosticSignHint = { link = "DiagnosticFloatingHint" },

        DiagnosticInfo = { fg = colors.pink_light, bold = true, style = "bold" },
        DiagnosticFloatingInfo = { fg = colors.pink_light, italic = true, style = "italic" },
        DiagnosticSignInfo = { link = "DiagnosticFloatingInfo" },

        DiagnosticUnderlineError = { undercurl = true, sp = colors.red, style = "undercurl" },
        DiagnosticUnderlineHint = { undercurl = true, sp = colors.magenta, style = "undercurl" },
        DiagnosticUnderlineInfo = { undercurl = true, sp = colors.pink_light, style = "undercurl" },
        DiagnosticUnderlineWarn = { undercurl = true, sp = colors.orange, style = "undercurl" },

        DiagnosticVirtualTextError = { fg = colors.red, bold = true, italic = true, style = "bold,italic" },
        DiagnosticVirtualTextWarn = { fg = colors.orange, bold = true, italic = true, style = "bold,italic" },
        DiagnosticVirtualTextInfo = { fg = colors.pink_light, bold = true, italic = true, style = "bold,italic" },
        DiagnosticVirtualTextHint = { fg = colors.magenta, bold = true, italic = true, style = "bold,italic" },

        ["@annotation"] = { link = "Label" },
        ["@variable"] = { fg = colors.gray_light },
        ["@variable.javascript"] = { link = "@variable" },
        ["@variable.typescript"] = { link = "@variable" },
        ["@variable.lua"] = { link = "@variable" },
        ["@attribute"] = { fg = colors.purple },
        ["@field"] = { link = "@variable", style = "undercurl", undercurl = true },
        ["@field.yaml"] = { link = "@field" },
        ["@field.rust"] = { link = "@field" },
        ["@field.lua"] = { link = "@field" },
        ["@string.regex"] = { link = "String", bold = true, undercurl = true, style = "bold,undercurl" },
        ["@text.strong"] = { link = "String", bold = true, style = "bold" }, -- For text to be represented with strong.
        ["@text.emphasis"] = { link = "String", italic = true, style = "italic" }, -- For text to be represented with emphasis.
        ["@type.definition"] = { bold = true, undercurl = true, style = "bold,undercurl" },

        rainbowcol1 = { fg = colors.red },
        rainbowcol2 = { fg = colors.yellow },
        rainbowcol3 = { fg = colors.orange },
        rainbowcol4 = { fg = colors.green },
        rainbowcol5 = { fg = colors.blue },
        rainbowcol6 = { fg = colors.cyan },
        rainbowcol7 = { fg = colors.purple },

        DiffviewFilePanelInsertions = { fg = colors.green_light },
        DiffviewFilePanelDeletions = { fg = colors.red_light },
    }
end
