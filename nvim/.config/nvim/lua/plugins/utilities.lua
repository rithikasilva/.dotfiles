return {
	-- Preview and Viewing Plugins
	{
		'chomosuke/typst-preview.nvim',
		lazy = false,
		version = '1.*',
		opts = {},
		config = function()
			vim.keymap.set('n', '<leader>tt', ':TypstPreviewToggle<CR>', { noremap = true, silent = true })
		end,
	},
	{
	  "iamcco/markdown-preview.nvim",
	  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	  build = "cd app && yarn install",
	  init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	  end,
	  ft = { "markdown" },
	},
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_view_compiler_method = "latexrun"
		end
	},
	{
		'cameron-wags/rainbow_csv.nvim',
		config = true,
		ft = {
			'csv',
			'tsv',
			'csv_semicolon',
			'csv_whitespace',
			'csv_pipe',
			'rfc_csv',
			'rfc_semicolon'
		},
		cmd = {
			'RainbowDelim',
			'RainbowDelimSimple',
			'RainbowDelimQuoted',
			'RainbowMultiDelim'
		}
	},
	-- General Utility
	{
		"voldikss/vim-floaterm",
		config = function()
			vim.keymap.set('n', '<C-p>', ':FloatermToggle<CR>', { noremap = true, silent = true })
			vim.keymap.set('t', '<C-p>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
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
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
		lazy = false,
	},
	{
		-- Normally against modifying navigation, this is worth it
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,   desc = "Flash" },
			{ "r", mode = "o",               function() require("flash").remote() end, desc = "Remote Flash" },
		},
	},
	-- In File Nice-to-haves
	{
		-- Auto-detect tabs, spaces, etc.. per opened file
		'tpope/vim-sleuth',
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		"allaman/emoji.nvim",
		version = "1.0.0",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		opts = {
			enable_cmp_integration = true,
		},
		config = function(_, opts)
			require("emoji").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},
	{
		'stevearc/quicker.nvim',
		event = "FileType qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
		config = function()
			vim.keymap.set("n", "<leader>q", function()
			  require("quicker").toggle()
			end, {
			  desc = "Toggle quickfix",
			})
			require("quicker").setup({
			})
		end,
	},
}
