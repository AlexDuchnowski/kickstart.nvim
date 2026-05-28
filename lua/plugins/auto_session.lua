return {
  'rmagatti/auto-session',
  lazy = false, -- auto-session must load at startup to restore the session

  ---enables autocomplete for opts
  ---@module 'auto-session'
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- log_level = 'debug',
  },
}
