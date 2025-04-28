return {
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
		-- Shiftwidth and expandtab settings
		'tpope/vim-sleuth',
	},
	{
		-- Preview markdown when I'm not using Obsidian
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
		-- Sometimes it's more convient to use this over tmux or nvim term
		"voldikss/vim-floaterm",
		config = function()
			vim.keymap.set('n', '<C-p>', ':FloatermToggle<CR>', { noremap = true, silent = true })
			vim.keymap.set('t', '<C-p>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })
		end,
	},
	{
		-- Convient tmux + nvim flow
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
		-- Automatic bracket pairing
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		-- Lualine
		'nvim-lualine/lualine.nvim',
		config = function()
			local palette = require("catppuccin.palettes.init").get_palette()
			local custom_catppuccin = require("lualine.themes.catppuccin")
			-- Note, background being not set is done in vim-options
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
							color = { bg = 'none' },
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
		-- Dependency for images
		"vhyrro/luarocks.nvim",
		priority = 1001,
		opts = {
			rocks = { "magick" },
		},
	},
	{
		-- Images
		"3rd/image.nvim",
		dependencies = { "luarocks.nvim" },
	},
	{
		-- Be able to compile and display conviently
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_view_compiler_method = "latexrun"
		end
	},
	{
		-- Better CSV preview
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
		-- I use emojis in blog posts
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
	}
}
