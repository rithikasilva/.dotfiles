return {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				ensure_installed = {'markdown', 'markdown_inline', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'yaml', 'latex' },
				auto_install = false,
				sync_install = false,
				ignore_install = {},
				modules = {},

				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
