function buf_text()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
  local text = ''
  for i, line in ipairs(lines) do
    text = text .. line .. '\n'
  end
  return text
end

function buf_vtext()
  local a_orig = vim.fn.getreg('a')
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then
    vim.cmd([[normal! gv]])
  end
  vim.cmd([[silent! normal! "aygv]])
  local text = vim.fn.getreg('a')
  vim.fn.setreg('a', a_orig)
  return text
end

function buf_text_or_vtext()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    return buf_vtext()
  end
  return buf_text()
end

function set_tmp_buf_options()
  local o = vim.opt_local
  o.bufhidden = 'delete'
  o.writebackup = false
  o.buflisted = false
  o.buftype = 'nowrite'
  o.updatetime = 300
end


return {
  buf_text = buf_text,
  buf_vtext = buf_vtext,
  buf_text_or_vtext = buf_text_or_vtext,
  set_tmp_buf_options = set_tmp_buf_options,
}
