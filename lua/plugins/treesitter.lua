local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

ts_config.setup {
   ensure_installed = "maintained",
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 500, -- Do not enable for files with more than n lines, int
   }
}

require("treesitter-context").setup()
