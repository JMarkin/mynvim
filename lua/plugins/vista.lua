vim.cmd([[
    let g:vista_executive_for = {
      \ 'sql': 'nvim_lsp',
      \ 'html': 'nvim_lsp',
      \ 'python': 'nvim_lsp',
      \ 'lua': 'nvim_lsp',
      \ 'rust': 'nvim_lsp',
      \ 'javascript': 'vim_lsp'
      \ }
    let g:vista_fzf_preview = ['right:50%']
    let g:vista#renderer#enable_icon = 1
]])
