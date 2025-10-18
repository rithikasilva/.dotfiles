return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			'stevearc/conform.nvim',
		},
		config = function()
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			local lspconfig = require("lspconfig")


			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config('jedi_language_server', {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			vim.lsp.config("clangd", {
				on_attach = on_attach,
				capabilities = capabilities
			})

			lspconfig.marksman.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			require("mason").setup()
			require("mason-lspconfig").setup()

			require("conform").setup({
				formatters_by_ft = {
					-- lua = { "stylua" },
					python = { "black" },
					rust = { "rustfmt" },
					cpp = { "clang_format_custom" },
					c = { "clang_format_custom" },
					json = { "clang_format_custom" },
					scss = { "prettier" },
				},
				formatters = {
					black = {
						args = { "--line-length", "100", "-" },
					},
					clang_format_custom = {
						command = "clang-format",
						args = function(_, ctx)
							local cwd = vim.fn.getcwd()
							local config_exists = vim.fn.globpath(cwd, ".clang-format") ~= ""

							if config_exists then
								return { "-style=file" }
							else
								return {
									"-style={BasedOnStyle: LLVM, IndentWidth: 2, TabWidth: 2, UseTab: ForIndentation}"
								}
							end
						end,
						stdin = true,
					},
				},
			})

			vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("conform").format()<CR>',
				{ noremap = true, silent = true })
		end,
	},
}
