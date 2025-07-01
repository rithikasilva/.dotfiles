return {
	{
		"robitx/gp.nvim",
		config = function()
			local conf = {
				providers = {
					openai = {},
					copilot = {
						disable = false,
						endpoint = "https://api.githubcopilot.com/chat/completions",
						secret = {
							"bash",
							"-c",
							"cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
						},
					},
				},
				agents = {
					{
						disable = false,
						provider = "copilot",
						name = "ChatCopilot",
						chat = true,
						command = false,
						model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
						system_prompt = require("gp.defaults").chat_system_prompt,
					},
				},
			}
			require("gp").setup(conf)

			vim.keymap.set('n', '<leader>ait', ':GpChatToggle<CR>', { desc = 'Toggle AI Window' })
			vim.keymap.set('n', '<leader>aic', ':GpChatToggle<CR>', { desc = 'Create AI Chat' })
		end,
	}
}
