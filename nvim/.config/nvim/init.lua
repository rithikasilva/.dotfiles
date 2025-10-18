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
  require 'plugins.snacks',
  require 'plugins.lsp',
  require 'plugins.git',
  require 'plugins.cmp',
  require 'plugins.utilities',
  require 'plugins.treesitter',
}, {})

vim.cmd.colorscheme("vague")

-- Some colourscheme overrides happen here
require("vim-options")
require("rg-to-qf")

