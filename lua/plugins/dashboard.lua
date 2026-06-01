-- Seed the RNG once so the random life expectancy actually varies. Neovim's LuaJIT
-- otherwise returns the same math.random() sequence on every launch. hrtime() gives a
-- high-resolution seed, avoiding the same-second collisions a bare os.time() would cause.
math.randomseed((vim.uv or vim.loop).hrtime() % 2147483647)

-- Generates a standard normal random number (mean=0, stddev=1)
local function standard_normal()
  local u1 = math.random()
  local u2 = math.random()

  local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
  return z0
end

-- Generates a normally distributed random number with a custom mean and standard deviation
local function custom_normal(mean, std_dev)
  local z0 = standard_normal() -- from the previous snippet
  return z0 * std_dev + mean
end

local function generate_memento_mori_display()
  local life_expectancy_weeks = math.ceil(custom_normal(77, 15) * 365 / 7)

  local dob = os.time { year = 2002, month = 6, day = 24 }
  local weeks_lived = math.ceil(os.difftime(os.time(), dob) / 604800)

  local display = '\n\n'
  local row_width = 150

  local lived = '='
  local current = '>'
  local unlived = '.'
  local blank = ' '

  for i = 0, math.ceil(life_expectancy_weeks / row_width) - 1 do
    local row = ''

    if (i + 1) * row_width < weeks_lived then
      row = row .. string.rep(lived, row_width)
    elseif weeks_lived > i * row_width then
      local partial_row_weeks = weeks_lived % row_width
      row = row .. string.rep(lived, partial_row_weeks - 1) .. current .. string.rep(unlived, row_width - partial_row_weeks)
    elseif life_expectancy_weeks < (i + 1) * row_width then
      local partial_row_weeks = life_expectancy_weeks % row_width
      row = row .. string.rep(unlived, partial_row_weeks) .. string.rep(blank, row_width - partial_row_weeks)
    else
      row = row .. string.rep(unlived, row_width)
    end

    row = row .. '\n'

    display = display .. row
  end

  display = display .. string.format('%s/%s\n', weeks_lived, life_expectancy_weeks) .. '\n\n'

  return display
end

return {
  {
    'nvimdev/dashboard-nvim',
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    -- dashboard-nvim only accepts `header` as a static list (unlike `footer`, it has no
    -- function branch), and lazy evaluates `opts` just once — so the memento-mori header is
    -- regenerated here, in a wrapper around the plugin's single render entry point
    -- (`instance`), which both the startup UIEnter autocmd and `:Dashboard` call.
    config = function(_, opts)
      local db = require 'dashboard'
      local orig_instance = db.instance
      db.instance = function(self, ...)
        if self.opts and self.opts.config then self.opts.config.header = vim.split(generate_memento_mori_display(), '\n') end
        return orig_instance(self, ...)
      end
      db.setup(opts)

      -- Reopen the dashboard once the last real file buffer is closed.
      local function is_real_file(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= ''
      end

      vim.api.nvim_create_autocmd('BufDelete', {
        group = vim.api.nvim_create_augroup('dashboard-on-empty', { clear = true }),
        callback = function(args)
          -- Schedule so the deletion settles and the replacement scratch buffer is created.
          vim.schedule(function()
            if vim.bo.filetype == 'dashboard' then return end
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if buf ~= args.buf and is_real_file(buf) then return end
            end
            vim.cmd 'Dashboard'
          end)
        end,
      })
    end,
    opts = function()
      local opts = {
        theme = 'doom',
        config = {
        -- stylua: ignore
        center = {
          { action = 'Telescope find_files',                           desc = " Find File",       icon = " ", key = "s" },
          { action = "Mason",                                          desc = " Mason",           icon = " ", key = "m" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == 'lazy' then
        vim.api.nvim_create_autocmd('WinClosed', {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function() vim.api.nvim_exec_autocmds('UIEnter', { group = 'dashboard' }) end)
          end,
        })
      end

      return opts
    end,
  },
}
