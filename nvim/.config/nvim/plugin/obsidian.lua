vim.pack.add({ 'https://github.com/obsidian-nvim/obsidian.nvim' })

require('obsidian').setup({
  workspaces = {
    { name = 'notes', path = '~/Documents/notes' },
  },
  daily_notes = {
    folder = 'daily',
    date_format = '%Y-%m-%d',
    default_tags = {},
    template = nil,
  },
  frontmatter = { enabled = false },
  legacy_commands = false,
})

vim.keymap.set('n', '<leader>nn', '<cmd>Obsidian today<CR>', { desc = 'Open today\'s note' })
vim.keymap.set('n', '<leader>ny', '<cmd>Obsidian yesterday<CR>', { desc = 'Open yesterday\'s note' })
vim.keymap.set('n', '<leader>nt', '<cmd>Obsidian tomorrow<CR>', { desc = 'Open tomorrow\'s note' })

vim.keymap.set('n', '<leader>nb', '<cmd>Obsidian backlinks<CR>', { desc = 'Note backlinks' })
vim.keymap.set('n', '<leader>ns', '<cmd>Obsidian search<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>nq', '<cmd>Obsidian quick_switch<CR>', { desc = 'Quick switch note' })
vim.keymap.set('x', '<leader>nl', ':Obsidian link<CR>', { desc = 'Link selection to note' })
vim.keymap.set('x', '<leader>nL', ':Obsidian link_new<CR>', { desc = 'Link selection to new note' })
