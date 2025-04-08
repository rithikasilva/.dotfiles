return {
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
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
}
