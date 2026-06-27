vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{
		src = "https://github.com/christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
})



-- require('lazy').setup({
--   require 'plugins.colourscheme',
--   require 'plugins.snacks',
--   require 'plugins.lsp',
--   require 'plugins.git',
--   require 'plugins.cmp',
--   require 'plugins.utilities',
--   require 'plugins.treesitter',
-- }, {})


-- Some colourscheme overrides happen here
require("vim-options")
-- require("rg-to-qf")



vim.cmd.colorscheme("vague")

