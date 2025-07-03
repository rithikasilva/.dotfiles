return {
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		keys = {
			{ "<C-n>",            function() Snacks.explorer() end,                     desc = "File Tree" },
			{ "<leader>sf",       function() Snacks.picker.files() end,                 desc = "Search Files" },
			{ "<leader>sh",       function() Snacks.picker.help() end,                  desc = "Search Help" },
			{ "<leader>sg",       function() Snacks.picker.grep() end,                  desc = "Search Grep" },
			{ "<leader>sl",       function() Snacks.picker.lines() end,                 desc = "Search Lines" },
			{ "<leader>sr",       function() Snacks.picker.resume() end,                desc = "Search Resume" },
			{ "<leader><leader>", function() Snacks.picker.buffers() end,               desc = "Open Buffer" },
			{ "<leader>z",        function() Snacks.zen.zoom() end,						desc = "Zoom" },
			{ "<leader>ss",       function() Snacks.picker.spelling() end,              desc = "Spell Suggest" },
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
			indent = { enabled = true },
			explorer = {
				enabled = true,
				replace_netrw = true,
			},
			picker = {
				enabled = true,
				layout = {
					preset = "bottom",
					preview = false,
				}
			},
		},
	},
}
