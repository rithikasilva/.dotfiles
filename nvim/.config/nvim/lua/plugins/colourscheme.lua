return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  { "slugbyte/lackluster.nvim" },
  { "shaunsingh/nord.nvim" },
  { "rose-pine/neovim", as = "rose-pine" },
  { "Hiroya-W/sequoia-moonlight.nvim", name = "sequoia",   priority = 1000 },
  config = function ()
    require("catppuccin").setup({})
    vim.cmd 'colorscheme catppuccin-mocha'
  end,
}
