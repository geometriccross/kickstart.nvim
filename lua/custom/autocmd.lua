require 'custom.utility'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set indent size
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  command = ':set shiftwidth=4 | set tabstop=4',
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Split windows when Enter the nvim',
  pattern = '*.*',
  callback = function()
    -- save pre settings
    local stored_splitright = vim.opt.splitright
    local stored_splitblow = vim.opt.splitbelow

    -- set a split setting, for stable a function behaivior
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- split window and tweak width
    vim.cmd ':vsplit | terminal'
    vim.cmd ':vertical resize -15'

    -- set a focus
    vim.cmd ':wincmd h'

    vim.opt.splitright = stored_splitright
    vim.opt.splitbelow = stored_splitblow
  end,
})

vim.api.nvim_create_autocmd('BufWrite', {
  desc = 'run shellspec if spec folder exists',
  pattern = '*.sh',
  callback = function()
    -- get a current dir
    local cwd = vim.fn.getcwd()

    -- check that the specific spec folder is exists
    if vim.fn.isdirectory(cwd .. '/' .. 'spec') == 1 then
      local term_bufs = GetTerminalBuffer()
      if #term_bufs == 0 then
        vim.cmd.vsplit()
      end

      -- select first terminal buffers
      local target_buf = term_bufs[1]
      SendToTerminal(target_buf, 'shellspec')
    end
  end,
})
