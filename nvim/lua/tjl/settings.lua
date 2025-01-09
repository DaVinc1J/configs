-- line numbering and autoindent
vim.opt.number = true
vim.opt.relativenumber = true

-- fold level
vim.o.foldlevel = 99

-- no mouse >:(
vim.opt.mouse = ""

vim.cmd [[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
]]

-- indenting
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- lua line symbol
require('lualine').setup({
	sections = {
		lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
	},
})
