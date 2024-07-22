-- Misc Settings
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true


-- Highlight on yank -> From Kickstart.nvim
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})


vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
	require('telescope.builtin').live_grep {
		grep_open_files = true,
		prompt_title = 'Live Grep in Open Files',
	}
end

vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })

vim.keymap.set('n', '<leader>sf', function()
	require('telescope.builtin').find_files({
		find_command = { 'rg', '--files', '--hidden', '--glob', '!.git' }
	})
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })




vim.keymap.set("n", "<leader>z", require("telescope").extensions.zoxide.list)
vim.opt.termguicolors = true


vim.g.vimtex_view_method = "zathura"



vim.o.tabstop = 4
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.wo.relativenumber = true


vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':terminal<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-p>', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-p>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-\\>', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-->', ':split<CR>', { noremap = true, silent = true })


-- Move current line up with Alt+j
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move current line down with Alt+k
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>tt', ':TSToggle highlight<CR>', { noremap = true, silent = true })



-- Need to manually specify the colours for the termianl if using neovide
if vim.g.neovide then
	vim.g.terminal_color_0  = "#45475a"
	vim.g.terminal_color_1  = "#f38ba8"
	vim.g.terminal_color_2  = "#a6e3a1"
	vim.g.terminal_color_3  = "#f9e2af"
	vim.g.terminal_color_4  = "#89b4fa"
	vim.g.terminal_color_5  = "#f5c2e7"
	vim.g.terminal_color_6  = "#94e2d5"
	vim.g.terminal_color_7  = "#bac2de"

	vim.g.terminal_color_8  = "#585b70"
	vim.g.terminal_color_9  = "#f38ba8"
	vim.g.terminal_color_10 = "#a6e3a1"
	vim.g.terminal_color_11 = "#f9e2af"
	vim.g.terminal_color_12 = "#89b4fa"
	vim.g.terminal_color_13 = "#f5c2e7"
	vim.g.terminal_color_14 = "#94e2d5"
	vim.g.terminal_color_15 = "#a6adc8"

	vim.g.terminal_color_16 = "#fab387"
	vim.g.terminal_color_17 = "#f5e0dc"


	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.15)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.15)
	end)

	vim.g.neovide_transparency = 1.0
end






