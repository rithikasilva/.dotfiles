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
  cmd = { 'clangd', '--background-index' },
  filetypes = { 'c', 'cpp', 'h' },
  root_markers = { 'compile_commands.json', '.clangd', '.git' },
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

local clangd_progress = vim.api.nvim_create_augroup('clangd_progress', { clear = true })

vim.api.nvim_create_autocmd('LspProgress', {
  group = clangd_progress,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= 'clangd' then
      return
    end

    local progress = ev.data.params.value
    if type(progress) ~= 'table' then
      return
    end

    local message = progress.message or progress.title or 'Indexing'
    if progress.percentage then
      message = ('[%3d%%] %s'):format(progress.percentage, message)
    end

    vim.notify(message, vim.log.levels.INFO, {
      id = 'clangd_progress',
      title = 'clangd',
    })
  end,
})

require('mason').setup()
