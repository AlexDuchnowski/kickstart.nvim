-- Add indentation guides even on blank lines

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
local highlight = {
  'CursorColumn',
  'Whitespace',
}
require('ibl').setup {
  indent = { highlight = highlight, char = '' },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  scope = { enabled = false },
  exclude = { filetypes = { 'dashboard' } },
}
