-- Everything related to colourscheme
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        integrations = {
          ts_rainbow = true,
          fidget = true,
        },
        color_overrides = {
          macchiato = {
            text = "#F4CDE9",
            subtext1 = "#DEBAD4",
            subtext0 = "#C8A6BE",
            overlay2 = "#B293A8",
            overlay1 = "#9C7F92",
            overlay0 = "#866C7D",
            surface2 = "#705867",
            surface1 = "#5A4551",
            surface0 = "#44313B",
            base = "#352939",
            mantle = "#211924",
            crust = "#1a1016",
          },
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")

      local mocha = require("catppuccin.palettes").get_palette "mocha"
      vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = mocha.subtext0 })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = mocha.subtext0 })
      vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = mocha.subtext0 })
    end,
  },
  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup({
        colors = {
          markdownBold = "red",
        }
      })
    end
  }
}
