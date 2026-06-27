vim.loader.enable()
require('vim._core.ui2').enable({})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('vim-options')
require('rg-to-qf')
