local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = require("ascii").get_random_global()

dashboard.section.buttons.val = {
    dashboard.button("f", "  Find File", "<cmd>lua require('fzf-lua').files({ multiprocess=true,})<Cr>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button(
        "r",
        "  Recent Files",
        '<cmd> lua require("fzf-lua").oldfiles({ multiprocess = true, cwd_only=true })<cr>'
    ),
    dashboard.button(
        "s",
        "  Find Text",
        "<cmd>lua require('fzf-lua').grep_project({  multiprocess=true,continue_last_search = true })<Cr>"
    ),
    dashboard.button("g", "  GIT", "<Cmd>Git<CR>"),
    dashboard.button("c", "  Local Configuration", ":e .vimrc.lua<CR>"),
    dashboard.button("l", "  Lazy.nvim", ":Lazy<CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa!<CR>"),
}

dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButton"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
