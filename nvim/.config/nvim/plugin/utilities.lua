vim.pack.add({
  -- CSV
  'https://github.com/cameron-wags/rainbow_csv.nvim',
  -- Navigation / motion
  'https://github.com/voldikss/vim-floaterm',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/folke/flash.nvim',
  -- In-file utilities
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/stevearc/quicker.nvim',
  'https://github.com/folke/todo-comments.nvim',
  -- Icons (oil dependency)
  'https://github.com/echasnovski/mini.icons',
})

-- floaterm
vim.keymap.set('n', '<C-p>', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-p>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })

-- vim-tmux-navigator
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>')
vim.keymap.set('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>')

-- oil
require('mini.icons').setup()
require('oil').setup()
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- flash
require('flash').setup()
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })

-- nvim-autopairs
require('nvim-autopairs').setup()

-- quicker
require('quicker').setup()
vim.keymap.set('n', '<leader>q', function() require('quicker').toggle() end, { desc = 'Toggle quickfix' })

-- todo-comments
require('todo-comments').setup()
