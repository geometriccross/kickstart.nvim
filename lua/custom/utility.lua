function GetTerminalBuffer()
  local term_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      table.insert(term_bufs, buf)
    end
  end
  return term_bufs
end

function SendToTerminal(bufnr, cmd)
  if vim.bo[bufnr].buftype ~= 'terminal' then
    print('Buffer ' .. bufnr .. ' is not a terminal')
    return
  end

  local term_job_id = vim.b[bufnr].terminal_job_id
  if not term_job_id then
    print('No terminal job ID found for buffer ' .. bufnr)
    return
  end

  vim.fn.chansend(term_job_id, cmd .. '\n')
end
