vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

-- Parsers for languages Neovim doesn't bundle (it ships c, lua, markdown,
-- markdown_inline, query, vim, vimdoc). Needed for fenced code blocks too.
-- Requires the `tree-sitter` CLI to compile parsers.
require('nvim-treesitter').install({
  'cpp',
  'bash',
  'python',
  'json',
  'yaml',
  'toml',
  'rust',
  'javascript',
  'typescript',
})

-- nvim-treesitter (main) no longer starts highlighting itself.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
