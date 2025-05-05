-- line numbering and autoindent
vim.opt.number = true
vim.opt.relativenumber = true

vim.cmd('highlight LineNr  guibg=NONE')
vim.cmd('highlight Comment guibg=NONE')
vim.cmd('highlight Todo guibg=NONE')
vim.cmd('highlight String guibg=NONE')
vim.cmd('highlight Constant guibg=NONE')

vim.cmd('highlight NonText guifg=NONE')

vim.cmd('highlight StatusLine guibg=NONE')
vim.cmd('highlight StatusLineNC guibg=NONE')

vim.cmd('highlight SignColumn guibg=NONE')

vim.cmd('highlight Error guibg=NONE')
vim.cmd('highlight ErrorMsg guibg=NONE')
vim.cmd('highlight Warning guibg=NONE')
vim.cmd('highlight WarningMsg guibg=NONE')

vim.cmd('highlight Directory guibg=NONE')

vim.o.incsearch = true
vim.o.hlsearch = true
vim.cmd [[autocmd CmdlineLeave * noh]]

-- fold level
vim.o.foldlevel = 99

-- no mouse >:(
vim.opt.mouse = ""

-- use alacritty mouse
vim.o.guicursor = "n-v-c-i:hor20-Cursor,a:blinkwait500-blinkon300-blinkoff300"

vim.cmd [[
		highlight Normal guibg=NONE ctermbg=NONE
		highlight NonText guibg=NONE ctermbg=NONE
]]

-- indenting
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true -- Convert tabs to spaces
-- lua line symbol
--require('lualine').setup({
--	sections = {
--		lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
--	},
--})
