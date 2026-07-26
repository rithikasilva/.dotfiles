-- Misc Settings
vim.o.hlsearch = true
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.tabstop = 4

vim.o.scrolloff = 4
vim.opt.cmdheight = 0
vim.wo.relativenumber = true
vim.o.conceallevel = 2

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})


-- Clear search highlights on Escape
vim.keymap.set('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Splitting
vim.keymap.set('n', '<M-\\>', ':vsplit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-->', ':split<CR>', { noremap = true, silent = true })


-- Auto center on Ctrl+u and Ctrl+d
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })


-- Resize Bindings
vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -3<CR>", { desc = "Narrow Window" })
vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +3<CR>", { desc = "Widen Window" })
vim.keymap.set("n", "<C-M-k>", "<cmd>resize +3<CR>", { desc = "Taller Window" })
vim.keymap.set("n", "<C-M-j>", "<cmd>resize -3<CR>", { desc = "Shorter Window" })

