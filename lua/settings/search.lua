local cmd = vim.cmd

return function(m)

m.nname("<leader>s", "Search")

----------Telescope
nnoremap("<leader>sf", "<cmd>lua require('fzf-lua').files()<Cr>", "Search: find files")
nnoremap("<leader>sg", "<cmd>lua require('fzf-lua').grep_project()<Cr>", "Search: project")
nnoremap("<leader>sl", "<cmd>lua require('fzf-lua').live_grep_native()<Cr>", "Search: live grep native")
nnoremap("<leader>sb", "<cmd>lua require('fzf-lua').lgrep_curbuf()<Cr>", "Search: current buffer")
nnoremap("<leader>st", "<cmd>lua require('fzf-lua').tags()<Cr>", "Search: tags")
nnoremap("<leader>sd", "<cmd>lua require('fzf-lua').lsp_definitions()<Cr>", "Search: Definitions")
nnoremap("<leader>sc", "<cmd>lua require('fzf-lua').commands()<Cr>", "Search: commands")
nnoremap("<leader>sch", "<cmd>lua require('fzf-lua').command_history()<Cr>", "Search: command_history")
end
