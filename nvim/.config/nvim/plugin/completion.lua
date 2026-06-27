vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' },
  'https://github.com/rafamadriz/friendly-snippets',
})

require('blink.cmp').setup({
  keymap = {
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<Esc>'] = { 'cancel', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = true } },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
