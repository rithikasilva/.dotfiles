-- return {
--   { "ellisonleao/gruvbox.nvim" },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "gruvbox",
--     },
--   },
-- }

-- return {
--   { "aditya-azad/candle-grey" },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "candle-grey",
--     },
--   },
-- }
-- return {
--   { "shaunsingh/nord.nvim" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "nord",
--     },
--   },
-- }
-- return {
--   { "folke/tokyonight.nvim" },

--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "tokyonight",
--     },
--   },
-- }
-- return {
--   { "rithikasilva/sequoia-monochrome.nvim" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "sequoia",
--     },
--   },
-- }
-- return {
--   { "nikolvs/vim-sunbather" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "sunbather",
--     },
--   },
-- }
-- return {
--   { "Lokaltog/vim-monotone" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "monotone",
--     },
--   },
-- }

return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
-- Lua

