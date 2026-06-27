vim.pack.add({
  'https://github.com/williamboman/mason.nvim',
})

local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('jedi_language_server', {
  cmd = { 'jedi-language-server' },
  filetypes = { 'python' },
  capabilities = capabilities,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'h' },
  capabilities = capabilities,
})

vim.lsp.config('ocamllsp', {
  cmd = { 'ocamllsp' },
  filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
  capabilities = capabilities,
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = true,
      check = { command = 'clippy' },
    },
  },
})

vim.lsp.enable({ 'lua_ls', 'jedi_language_server', 'clangd', 'ocamllsp', 'rust_analyzer' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: [R]e[n]ame' })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'LSP: Show diagnostic' })
  end,
})

require('mason').setup()
