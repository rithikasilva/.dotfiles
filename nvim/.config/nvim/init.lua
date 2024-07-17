vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
  require 'custom.plugins.git',
  require 'custom.plugins.sleuth',
  require 'custom.plugins.lsp',
  require 'custom.plugins.colourscheme',
  require 'custom.plugins.cmp',
  require 'custom.plugins.telescope',
  require 'custom.plugins.utilities',
  require 'custom.plugins.which-key',
  require 'custom.plugins.nvim-tree',
  require 'custom.plugins.gitsigns',
  require 'custom.plugins.treesitter',
}, {})

require("custom.vim-options")

