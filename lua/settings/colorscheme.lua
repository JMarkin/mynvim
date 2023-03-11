local highlite = require("highlite")

local black = { "#202020", 235, "black" }
local gray = { "#808080", 244, "gray" }
local gray_dark = { "#353535", 236, "darkgrey" }
local gray_darker = { "#505050", 239, "gray" }
local gray_light = { "#c0c0c0", 250, "gray" }
local white = { "#ffffff", 231, "white" }

local tan = { "#f4c069", 221, "yellow" }

local red = { "#ee4a59", 203, "red" }
local red_dark = { "#a80000", 124, "darkred" }
local red_light = { "#ff4090", 205, "red" }

local orange = { "#ff8900", 208, "darkyellow" }
local orange_light = { "#f0af00", 214, "darkyellow" }

local yellow = { "#f0df33", 227, "yellow" }

local green_dark = { "#70d533", 113, "darkgreen" }
local green = { "#22ff22", 46, "green" }
local green_light = { "#99ff99", 120, "green" }
local turqoise = { "#2bff99", 48, "green" }

local blue = { "#7766ff", 63, "darkblue" }
local cyan = { "#33dbc3", 80, "cyan" }
local ice = { "#95c5ff", 111, "cyan" }
local teal = { "#60afff", 75, "blue" }

local magenta = { "#d5508f", 168, "magenta" }
local magenta_dark = { "#bb0099", 126, "darkmagenta" }
local pink = { "#ffa6ff", 219, "magenta" }
local pink_light = { "#ffb7b7", 217, "white" }
local purple = { "#cf55f0", 171, "magenta" }
local purple_light = { "#af60af", 133, "darkmagenta" }

local group = {
    Error = { fg = red_dark, bold = true },
    ErrorMsg = { fg = red, bold = true },
    ModeMsg = { fg = yellow },
    Question = { fg = orange_light, underline = true },
    Todo = { fg = cyan, bold = true },
    WarningMsg = { fg = orange, bold = true },

    DiagnosticError = "Error",
    DiagnosticFloatingError = "ErrorMsg",
    DiagnosticSignError = "DiagnosticFloatingError",

    DiagnosticWarn = { fg = orange, bold = true },
    DiagnosticFloatingWarn = "WarningMsg",
    DiagnosticSignWarn = "DiagnosticFloatingWarn",

    DiagnosticHint = { fg = magenta, bold = true },
    DiagnosticFloatingHint = { fg = magenta, italic = true },
    DiagnosticSignHint = "DiagnosticFloatingHint",

    DiagnosticInfo = { fg = pink_light, bold = true },
    DiagnosticFloatingInfo = { fg = pink_light, italic = true },
    DiagnosticSignInfo = "DiagnosticFloatingInfo",

    DiagnosticUnderlineError = { undercurl = true, sp = red },
    DiagnosticUnderlineHint = { undercurl = true, sp = magenta },
    DiagnosticUnderlineInfo = { undercurl = true, sp = pink_light },
    DiagnosticUnderlineWarn = { undercurl = true, sp = orange },

    DiagnosticVirtualTextError = { fg = red, bold = true, italic = true },
    DiagnosticVirtualTextWarn = { fg = orange, bold = true, italic = true },
    DiagnosticVirtualTextInfo = { fg = pink_light, bold = true, italic = true },
    DiagnosticVirtualTextHint = { fg = magenta, bold = true, italic = true },

    ["@annotation"] = "Label",
    ["@attribute"] = { fg = purple },
    ["@field"] = "ParamIdentifier",
    ["@string.regex"] = { link = "String", bold = true, undercurl = true },
    ["@text.strong"] = { link = "String", bold = true }, -- For text to be represented with strong.
    ["@text.emphasis"] = { link = "String", italic = true }, -- For text to be represented with emphasis.
    ["@type.definition"] = { bold = true, undercurl = true },

    rainbowcol1 = { fg = red },
    rainbowcol2 = { fg = yellow },
    rainbowcol3 = { fg = orange },
    rainbowcol4 = { fg = green },
    rainbowcol5 = { fg = blue },
    rainbowcol6 = { fg = cyan },
    rainbowcol7 = { fg = purple },

    DiffviewNormal = "Normal",
    DiffviewNonText = "NonText",
    DiffviewCursorLine = "CursorLine",
    DiffviewWinSeparator = "WinSeparator",
    DiffviewSignColumn = "Normal",
    DiffviewStatusLine = "StatusLine",
    DiffviewStatusLineNC = "StatusLineNC",
    DiffviewEndOfBuffer = "EndOfBuffer",
    DiffviewFilePanelRootPath = "DiffviewFilePanelTitle",
    DiffviewFilePanelFileName = "Normal",
    DiffviewFilePanelPath = "Comment",
    DiffviewFilePanelInsertions = { fg = teal },
    DiffviewFilePanelDeletions = { fg = red },
    DiffviewFilePanelConflicts = "DiagnosticSignWarn",
    DiffviewFolderName = "Directory",
    DiffviewFolderSign = "PreProc",
    DiffviewReference = "Function",
    DiffviewStatusAdded = "diffAdded",
    DiffviewStatusUntracked = "diffAdded",
    DiffviewStatusModified = "diffChanged",
    DiffviewStatusRenamed = "diffChanged",
    DiffviewStatusCopied = "diffChanged",
    DiffviewStatusTypeChange = "diffChanged",
    DiffviewStatusUnmerged = "diffChanged",
    DiffviewStatusUnknown = "diffRemoved",
    DiffviewStatusDeleted = "diffRemoved",
    DiffviewStatusBroken = "diffRemoved",
    DiffviewStatusIgnored = "Comment",
}

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        highlite.highlight_all(group)
    end,
    group = vim.api.nvim_create_augroup("config", { clear = true }),
    pattern = "highlite",
})

vim.cmd("colorscheme highlite")
