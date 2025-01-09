-- general keymapping
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Go back to nvim file menu" })

-- reload lua
vim.api.nvim_set_keymap('n', '<leader>r', ':luafile $MYVIMRC<CR>', { noremap = true, silent = true })

-- telescope keymapping
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>ps', function()
	require('telescope.builtin').live_grep({ default_text = vim.fn.input("Grep > ") })
end, { desc = 'Grep files' })

-- sharing clipboards between system and nvim
vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'p', '"+p', { noremap = true, silent = true })

-- undotree keymapping
vim.keymap.set('n', '<leader>pu', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })

-- nvim-cmp keymapping
local cmp = require("cmp")

vim.keymap.set('i', '<C-d>', cmp.mapping.scroll_docs(-4), { desc = 'Scroll documentation up' })
vim.keymap.set('i', '<C-f>', cmp.mapping.scroll_docs(4), { desc = 'Scroll documentation down' })
vim.keymap.set('i', '<C-Space>', cmp.mapping.complete(), { desc = 'Trigger completion' })
vim.keymap.set('i', '<C-e>', cmp.mapping.close(), { desc = 'Close completion' })
vim.keymap.set('i', '<CR>', cmp.mapping.confirm({
	behavior = cmp.ConfirmBehavior.Replace,
	select = true,
}), { desc = 'Confirm selection' })

-- harpoon remapping
local harpoon = require('harpoon')
harpoon.setup({})

vim.keymap.set("n", "<leader>pa", function() harpoon:list():add() end, { desc = 'Add file to harpoon menu' })
vim.keymap.set("n", "<leader>pq", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
	{ desc = 'Open harpoon menu' })

vim.keymap.set("n", "<leader>ph", function() harpoon:list():select(1) end, { desc = '1st file in harpoon menu' })
vim.keymap.set("n", "<leader>pj", function() harpoon:list():select(2) end, { desc = '2st file in harpoon menu' })
vim.keymap.set("n", "<leader>pk", function() harpoon:list():select(3) end, { desc = '3st file in harpoon menu' })
vim.keymap.set("n", "<leader>pl", function() harpoon:list():select(4) end, { desc = '4st file in harpoon menu' })

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers").new({}, {
		prompt_title = "Harpoon",
		finder = require("telescope.finders").new_table({
			results = file_paths,
		}),
		previewer = conf.file_previewer({}),
		sorter = conf.generic_sorter({}),
	}):find()
end

vim.keymap.set("n", "<leader>pt", function() toggle_telescope(harpoon:list()) end,
	{ desc = "Open harpoon window" })

-- table mode keymapping
vim.keymap.set('n', '<leader>tm', function() vim.cmd.TableModeToggle() end, { desc = "Toggle Table Mode" })

local colors_enabled = true

function ToggleColorscheme()
	if colors_enabled then
		-- Save current background and syntax settings
		vim.g.saved_background = vim.o.background
		vim.g.saved_syntax = vim.api.nvim_get_option('syntax')

		-- Switch to plain black-and-white mode
		vim.cmd('syntax off')   -- Turn off syntax highlighting
		vim.o.background = 'dark' -- Set background to dark (black)
		vim.cmd('hi clear')     -- Clear all previous highlight groups
		vim.cmd('set t_Co=0')   -- Set terminal colors to 0 to disable colors

		-- Define all key highlight groups to be black and white
		vim.cmd('highlight Normal guibg=black guifg=white') -- Normal text (white on black)
		vim.cmd('highlight Comment guifg=white')          -- Comments (white)
		vim.cmd('highlight LineNr guifg=white')           -- Line numbers (white)
		vim.cmd('highlight NonText guifg=white')          -- Non-text (whitespace markers)
		vim.cmd('highlight SpecialKey guifg=white')       -- Special characters (e.g., tabs)
		vim.cmd('highlight Identifier guifg=white')       -- Identifiers (variables, etc.)
		vim.cmd('highlight Statement guifg=white')        -- Statements (e.g., if, while)
		vim.cmd('highlight PreProc guifg=white')          -- Preprocessor directives
		vim.cmd('highlight Type guifg=white')             -- Types (e.g., int, char)
		vim.cmd('highlight Constant guifg=white')         -- Constants (e.g., numbers)
		vim.cmd('highlight String guifg=white')           -- Strings
		vim.cmd('highlight Function guifg=white')         -- Functions
		print("Black-and-white mode enabled")
	else
		-- Restore original settings
		vim.cmd('hi clear')                               -- Clear custom highlights
		vim.o.background = vim.g.saved_background or 'dark' -- Restore background
		vim.cmd('colorscheme farout')                     -- Restore farout.nvim colorscheme
		if vim.g.saved_syntax == '' then
			vim.cmd('syntax enable')
		else
			vim.cmd('syntax on')
		end
		print("farout.nvim colorscheme restored")
	end
	colors_enabled = not colors_enabled
end

vim.api.nvim_set_keymap('n', '<leader>bw', ':lua ToggleColorscheme()<CR>', { noremap = true, silent = true })
