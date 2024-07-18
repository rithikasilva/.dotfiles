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
  require 'plugins.colourscheme',
  require 'plugins.git',
  require 'plugins.lsp',
  require 'plugins.cmp',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.utilities',
  require 'plugins.which-key',
  require 'plugins.nvim-tree',
}, {})

require("vim-options")

