-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local keymap = vim.keymap

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [e]rror in float' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

--  See `:help wincmd` for a list of all window commands
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Easy file write with leader [from Alex]
keymap.set('n', '<leader>w', ':w!<CR>', { desc = 'Write file changes' })

-- LSP keymaps
keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature help' })
keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = 'Rename symbol under cursor' })
