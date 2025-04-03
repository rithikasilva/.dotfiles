-- LSP Stuff. Most of this is directly copied from Kickstart.nvim
return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',
			{
				'j-hui/fidget.nvim',
				opts = {
					notification = { window = { winblend = 0 } },
				}
			},
			'folke/neodev.nvim',
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
				nmap('<leader>ca', function()
					vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
				end, '[C]ode [A]ction')

				nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
				nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
				nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
				nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
				nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
				nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'Format current buffer with LSP' })
			end


			require('mason').setup()
			require('mason-lspconfig').setup()
			require('neodev').setup()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				ltex = {
					settings = {
						ltex = {
							dictionary = {
								["en-US"] = { "Neovim", "neovim", "Rithika", "Silva" },
							},
						},
					},
				},
			}

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				ensure_installed = vim.tbl_keys(servers),
			}

			mason_lspconfig.setup_handlers {
				function(server_name)
					local opts = {
						capabilities = capabilities,
						on_attach = on_attach,
					}

					-- Merge server-specific settings if available
					if servers[server_name] then
						for k, v in pairs(servers[server_name]) do
							opts[k] = v
						end
					end

					require('lspconfig')[server_name].setup(opts)
				end,
			}
		end,
	},
	{
		'nvimdev/guard.nvim',
		dependencies = {
			'nvimdev/guard-collection'
		},
		config = function()
			local ft = require('guard.filetype')
			ft('python'):fmt({
				cmd = 'black',
				args = { '--line-length', '100', '-' },
				stdin = true,
			})

			-- Can't use require for this plugin		
			vim.g.guard_config = {
				fmt_on_save = false,
				lsp_as_default_formatter = false,
			}

			-- Associated keybinding
			vim.api.nvim_set_keymap('n', '<leader>ff', ':Guard fmt<CR>', { noremap = true, silent = true })
		end,
	}
}
