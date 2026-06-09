return {
  'rmagatti/auto-session',
  lazy = false, -- auto-session must load at startup to restore the session
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>ss', '<cmd>AutoSession search<CR>', desc = 'Session search' },
    -- { '<leader>as', '<cmd>AutoSession save<CR>', desc = 'Save session' },
    { '<leader>ta', '<cmd>AutoSession toggle<CR>', desc = '[T]oggle [A]utosession Autosave' },
  },

  ---enables autocomplete for opts
  ---@module 'auto-session'
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  },
}
