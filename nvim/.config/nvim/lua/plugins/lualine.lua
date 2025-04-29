return {
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local auto_custom = require('lualine.themes.auto')
			auto_custom.normal.c.bg = "#141415"
			require('lualine').setup({
				options = {
					theme = auto_custom,
					section_separators = { '', '' },
					component_separators = { '', '' },
					globalstatus = true,
				},
				sections = {
					lualine_a = {
					},
					lualine_b = {},
					lualine_c = {
						{ 'mode', color = { bg = '#141415', fg = '#cdcdcd' } },
						{ 'branch', color = { bg = '#141415', fg = '#cdcdcd' } },
						{ 'diff', color = { bg = '#141415', fg = '#cdcdcd' } },
					},
					lualine_x = {
						{ 'filename', color = { bg = '#141415', fg = '#cdcdcd' } },
						{ 'progress', color = { bg = '#141415', fg = '#cdcdcd' } },
					},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
