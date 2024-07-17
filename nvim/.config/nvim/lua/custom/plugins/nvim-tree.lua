return {
	{
		'kyazdani42/nvim-tree.lua',
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require 'nvim-tree'.setup {
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
				}
			}
		end
	},

}
