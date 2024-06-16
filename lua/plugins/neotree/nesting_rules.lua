local rules = require("neotree-file-nesting-config").nesting_rules

rules["README.*"] = {
    files = {
        "AUTHORS",
        "BACKERS*",
        "CHANGELOG*",
        "CITATION*",
        "CODE_OF_CONDUCT*",
        "CODEOWNERS",
        "CONTRIBUTING*",
        "CONTRIBUTORS",
        "COPYING*",
        "CREDITS",
        "GOVERNANCE%.MD",
        "HISTORY%.MD",
        "LICENSE*",
        "MAINTAINERS",
        "RELEASE_NOTES*",
        "SECURITY%.MD",
        "SPONSORS*",
        "README-*",
        "USAGE.md",
        "ENV.md",
    },
    ignore_case = true,
    pattern = "README%.(.*)$",
}

return rules
