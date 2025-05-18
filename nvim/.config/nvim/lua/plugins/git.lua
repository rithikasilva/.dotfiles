return {
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function()
				local gs = package.loaded.gitsigns

				-- normal mode
				vim.keymap.set('n', '<leader>hn', gs.next_hunk, { desc = 'git next hunk' })
				vim.keymap.set('n', '<leader>hp', gs.prev_hunk, { desc = 'git previous hunk' })

				vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
				vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
				vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
				vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
				vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })

				vim.keymap.set('n', '<leader>hP', gs.preview_hunk_inline, { desc = 'preview git hunk' })
				vim.keymap.set('n', '<leader>hb', function()
					gs.blame_line { full = false }
				end, { desc = 'git blame line' })
				vim.keymap.set('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
				vim.keymap.set('n', '<leader>hD', function()
					gs.diffthis '~'
				end, { desc = 'git diff against last commit' })
			end,
		},
	},
	{
		'akinsho/git-conflict.nvim',
		version = "*",
		config = function()
			require('git-conflict').setup()
			vim.keymap.set('n', '<leader>gco', ":GitConflictChooseOurs<CR>", {desc = 'Conflict Choose Ours'} )
			vim.keymap.set('n', '<leader>gct', ":GitConflictChooseTheirs<CR>", {desc = 'Conflict Choose Theirs'} )
			vim.keymap.set('n', '<leader>gcb', ":GitConflictChooseBoth<CR>", {desc = 'Conflict Choose Both'} )
			vim.keymap.set('n', '<leader>gcq', ":GitConflictListQf<CR>", {desc = 'Conflict Quickfix'} )

		end,
	}
}
