return {
	{
		'tpope/vim-sleuth',
	},
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{ "voldikss/vim-floaterm" },
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
			local custom_catppuccin = require("lualine.themes.catppuccin")
			custom_catppuccin.normal.c.bg = 'none' -- Deal with the background on dashes
			require('lualine').setup({
				options = {
					theme = custom_catppuccin,
					section_separators = '',
					component_separators = '',
					globalstatus = true,
					always_divide_middle = true,
				},
				sections = {
					lualine_a = {
						{
							'branch',
							icon = '',
							color = { bg = 'none', fg = palette.text },
							padding = 0,
						},
					},
					lualine_b = {
						{
							color = { bg = 'none' },
							padding = 0,
						},
					},
					lualine_c = {
						"%=",
						{
							function()
								return vim.fn.expand('%:t') .. " "
							end,
							color = { bg = 'none', fg = palette.text },
							padding = 0,
						},
					},
					lualine_x = {
						{
							color = { bg = 'none' },
							padding = 0,
						}
					},
					lualine_y = {
						{
							padding = 0,
						}
					},
					lualine_z = {
						{
							"progress",
							color = { bg = 'none', fg = palette.text },
							padding = { left = 1, right = 0 },
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
	{
		'kyazdani42/nvim-tree.lua',
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require("nvim-tree").setup {
				disable_netrw       = true,
				hijack_netrw        = true,
				open_on_tab         = false,
				hijack_cursor       = false,
				update_cwd          = false,
				update_focused_file = {
					enable      = false,
					update_cwd  = false,
					ignore_list = {}
				},
				system_open         = {
					cmd  = nil,
					args = {}
				},
				view                = {
					width = 30,
					side = 'left',
				},
			}
		end
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_output_win_max_height = 12
		end,
	},
	{
		'goerz/jupytext.nvim',
		version = '0.2.0',
		opts = {}, -- see Options
	}
}
