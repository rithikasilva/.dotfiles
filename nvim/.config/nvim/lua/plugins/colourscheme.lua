return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({})
      vim.cmd.colorscheme("catppuccin-mocha")


      local mocha = require("catppuccin.palettes").get_palette "mocha"
      vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = mocha.subtext0 })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = mocha.subtext0 })
      vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = mocha.subtext0 })
    end,
  },
  { "slugbyte/lackluster.nvim" },
  { "shaunsingh/nord.nvim" },
  { "rose-pine/neovim",                as = "rose-pine" },
  { "Hiroya-W/sequoia-moonlight.nvim", name = "sequoia", priority = 1000 },
}
