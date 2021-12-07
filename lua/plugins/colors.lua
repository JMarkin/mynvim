local present, lualine = pcall(require, "lualine")
if not present then
   return
end

return function()
--- gruvbox
    vim.g.gruvbox_material_background = 'soft'
    vim.g.gruvbox_material_palette = 'mix'
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_enable_bold = true
    vim.g.gruvbox_material_diagnostic_text_highlight = true
    vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
    vim.g.gruvbox_material_diagnostic_line_highlight = true
 --- sonokai
    vim.g.sonokai_style = 'andromeda'
    vim.g.sonokai_enable_italic = true
    vim.g.sonokai_enable_bold = true
    vim.g.sonokai_diagnostic_text_highlight = true
    vim.g.sonokai_diagnostic_virtual_text = 'colored'
    vim.g.sonokai_diagnostic_line_highlight = true
    
    vim.opt.background='dark'
    vim.cmd "colorscheme sonokai"

    lualine.setup({
      options = {
        theme = 'sonokai'
      },
      extensions = {'quickfix'},
      sections = {
        lualine_a = {'mode'},
        lualine_b = {
            'branch',
            'diff',
            {'diagnostics', sources={'nvim_lsp'}}
        },
        lualine_c = {
            {'filename', path=1}
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
    })
end

