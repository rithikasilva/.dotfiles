return {
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
		'folke/snacks.nvim',
		keys = {
			-- Note that closing is just q by default
			{ "<C-n>",            function() Snacks.explorer() end,                     desc = "File Tree" },
			{ "<leader>gg",       function() Snacks.lazygit() end,                      desc = "Lazygit" },
			{ "<leader>sf",       function() Snacks.picker.files() end,                 desc = "Search Files" },
			{ "<leader>sh",       function() Snacks.picker.help() end,                  desc = "Search Help" },
			{ "<leader>sg",       function() Snacks.picker.grep() end,                  desc = "Search Grep" },
			{ "<leader>sr",       function() Snacks.picker.resume() end,                desc = "Search Resume" },
			{ "<leader><leader>", function() Snacks.picker.buffers() end,               desc = "Open Buffer" },
			{ "<leader>z",        function() Snacks.picker.zoxide() end,                desc = "Zoxide Open Project" },
			{ "<leader>ss",       function() Snacks.picker.spelling() end,              desc = "Spell Suggest" },
			-- Lsp things
			{ "gd",               function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
			{ "gD",               function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
			{ "gr",               function() Snacks.picker.lsp_references() end,        desc = "Goto References" },
			{ "gI",               function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
			{ "D",                function() Snacks.picker.lsp_definitions() end,       desc = "Type Definitions" },
			{ "ds",               function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
			{ "ws",               function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		},
		opts = {
			inputs = { enabled = true },
			lazygit = {
				enabled = true,
				configure = true,
				os = { editPreset = "nvim-remote" }
			},
			indent = { enabled = true },
			explorer = {
				enabled = true,
				replace_netrw = true,
			},
			picker = {
				enabled = true,
			},
		},

	},
	{
		-- Lualine
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
