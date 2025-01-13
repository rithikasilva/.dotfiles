return {
	{
		'tpope/vim-sleuth',
	},
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{ "voldikss/vim-floaterm" },
	-- {
	-- 	"christoomey/vim-tmux-navigator",
	-- 	cmd = {
	-- 		"TmuxNavigateLeft",
	-- 		"TmuxNavigateDown",
	-- 		"TmuxNavigateUp",
	-- 		"TmuxNavigateRight",
	-- 		"TmuxNavigatePrevious",
	-- 	},
	-- 	keys = {
	-- 		{ "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
	-- 		{ "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
	-- 		{ "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
	-- 		{ "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
	-- 		{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	-- 	},
	-- },
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		'stevearc/dressing.nvim',
		opts = {},
	},
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local palette = require("catppuccin.palettes.init").get_palette()
			require('lualine').setup({
				options = {
					theme = "catppuccin",
					section_separators = '',
					component_separators = '',
				},
				sections = {
					lualine_a = {
						{
							"filename",
							path = 1,
							separator = { left = '', right = '' },
							color = { bg = palette.pink, fg = palette.base, gui = "bold" },
							padding = 0,
							shorting_target = 0,
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							"%l/%L,%c",
							color = { bg = palette.mantle, fg = palette.text },
							padding = 1,
						},
						{
							"filetype",
							color = { bg = palette.mantle, fg = palette.text },
							padding = 0,
						},
					},
				},
				inactive_sections = {
					lualine_a = {
						{
							'filename',
							path = 1,
							color = { fg = palette.surface1 },
							padding = 1,
							shorting_target = 0,
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							"%l/%L,%c",
							color = { bg = palette.mantle, fg = palette.surface1 },
							padding = 1,
						},
						{
							"filetype",
							color = { bg = palette.mantle, fg = palette.surface1 },
							padding = 0,
						},
					},
				},
			})
		end,
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1001,
		opts = {
			rocks = { "magick" },
		},
	},
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup {
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			}

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
	{
		"3rd/image.nvim",
		dependencies = { "luarocks.nvim" },
	},
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
		end
	},
	{ "ThePrimeagen/vim-be-good", name = "VimBeGood", priority = 1000 },
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
	{ 'mrjones2014/smart-splits.nvim' },
}
