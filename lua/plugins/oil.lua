return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { '-', '<CMD>Oil --preview<CR>', desc = 'Open parent directory' },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function(_, opts)
      require('oil').setup(opts)

      -- Auto-open the preview whenever an Oil buffer is entered (covers `nvim <dir>`,
      -- the `-` keymap, and the dashboard action)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'OilEnter',
        callback = vim.schedule_wrap(function(args)
          local oil = require 'oil'
          if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            oil.open_preview()
          end
        end),
      })
    end,
  },
}
