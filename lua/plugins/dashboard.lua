return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'doom',
        config = {
          week_header = {
            enable = true,
          },
          center = {
            -- {
            --   icon = ' ',
            --   icon_hl = 'Title',
            --   desc = 'Find File           ',
            --   desc_hl = 'String',
            --   key = 'b',
            --   keymap = 'SPC s f',
            --   key_hl = 'Number',
            --   key_format = ' %s', -- remove default surrounding `[]`
            --   action = 'lua print(2)',
            -- },
          },
          -- footer = {}, --your footer
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}
