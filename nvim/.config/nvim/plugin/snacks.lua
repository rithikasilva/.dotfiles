vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

require('snacks').setup({
  inputs = { enabled = true },
  indent = { enabled = true },
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  picker = {
    enabled = true,
    layout = {
      preset = 'bottom',
      preview = false,
    },
  },
})

vim.keymap.set('n', '<C-n>', function() Snacks.explorer() end, { desc = 'File Tree' })
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sl', function() Snacks.picker.lines() end, { desc = 'Search Lines' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = 'Search Resume' })
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = 'Open Buffer' })
vim.keymap.set('n', '<leader>z', function() Snacks.zen.zoom() end, { desc = 'Zoom' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.spelling() end, { desc = 'Spell Suggest' })
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'Goto References' })
vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'D', function() Snacks.picker.lsp_definitions() end, { desc = 'Type Definitions' })
vim.keymap.set('n', 'ds', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
vim.keymap.set('n', 'ws', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
