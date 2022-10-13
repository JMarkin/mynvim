local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    [[]],
    [[]],
    [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
    [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
    [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
    [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
    [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
    [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╚═╝     ╚═╝ ]],
}

dashboard.section.buttons.val = {
    dashboard.button("f", "  Find File", "<cmd>lua require('fzf-lua').files({ multiprocess=true,})<Cr>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recent Files", "<cmd>lua require('plugins.fzflua').search_old_files()<cr>"),
    dashboard.button(
        "t",
        "  Find Text",
        "<cmd>lua require('fzf-lua').grep_project({  multiprocess=true,continue_last_search = true })<Cr>"
    ),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
    dashboard.button("l", "  Local Configuration", ":e .lvimrc<CR>"),
    dashboard.button("u", "  Update Plugins", ":PackerSync<CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa!<CR>"),
}

local footer = function()
    local version = " " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    if packer_plugins == nil then
        return version
    else
        local total_plugins = "   " .. #vim.tbl_keys(packer_plugins) .. " Plugins"
        return version .. total_plugins
    end
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButton"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)