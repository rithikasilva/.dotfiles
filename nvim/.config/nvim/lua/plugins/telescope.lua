return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				},
			}
			require('telescope').load_extension("zoxide")

			pcall(require('telescope').load_extension, 'fzf')


			local function find_git_root()
				local current_file = vim.api.nvim_buf_get_name(0)
				local current_dir
				local cwd = vim.fn.getcwd()
				if current_file == '' then
					current_dir = cwd
				else
					current_dir = vim.fn.fnamemodify(current_file, ':h')
				end
				local git_root = vim.fn.systemlist('git -C ' ..
				vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
				if vim.v.shell_error ~= 0 then
					print 'Not a git repository. Searching on current working directory'
					return cwd
				end
				return git_root
			end

			local function live_grep_git_root()
				local git_root = find_git_root()
				if git_root then
					require('telescope.builtin').live_grep {
						search_dirs = { git_root },
					}
				end
			end
			vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
		end,
	},
}
