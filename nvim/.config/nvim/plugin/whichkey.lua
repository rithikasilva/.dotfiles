vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

require('which-key').setup()

require('which-key').add({
  { '<leader>g', group = 'Git' },
  { '<leader>h', group = 'Git Hunk' },
  { '<leader>n', group = 'Notes' },
  { '<leader>s', group = 'Search' },
})

require('which-key').add({
  { '<leader>h', group = 'Git Hunk', mode = 'v' },
  { '<leader>n', group = 'Notes', mode = 'v' },
})
