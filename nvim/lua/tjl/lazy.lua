vim.opt.runtimepath:prepend("~/.config/nvim/lazy/lazy.nvim")

require('lazy').setup({
	{
		'nvim-telescope/telescope.nvim',
		event = 'BufRead',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require 'telescope'.setup {
				defaults = {
					prompt_prefix = "> ",
					sorting_strategy = "ascending",
				},
			}
		end
	},

	{
		'thallada/farout.nvim',
		lazy = false,
		priority = 1000,
		init = function()
			vim.cmd.colorscheme('farout')
		end
	},


	{
		'windwp/nvim-ts-autotag',
		config = function()
			require('nvim-ts-autotag').setup()
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = 'BufRead',
		config = function()
			require('nvim-ts-autotag').setup({
				autotag = {
					enable = true,
				},
			})

			require('nvim-treesitter.configs').setup({
				ensure_installed = { "c", "norg", "lua", "python", "ruby", "latex", "vim", "vimdoc", "query", "rust", "css", "html", "javascript", "typescript" },

				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true
				},

				rainbow = {
					enable = true,
					extended_mode = false,
					max_file_lines = nil,
				},

				incremental_selection = {
					enable = true,
				},
			})
		end,
	},

	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = function()
			require('nvim-autopairs').setup({
				disable_filetype = { 'TelescopePrompt', 'vim' },
			})
		end,
	},

	{
		'lervag/vimtex',
		ft = 'tex',
		config = function()
			vim.g.vimtex_view_method = 'skim'
			vim.g.vimtex_view_general_viewer = 'skim'
			vim.g.vimtex_compiler_method = 'latexmk'
			vim.g.vimtex_fold_enabled = 1
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			{
				'L3MON4D3/LuaSnip',
				version = 'v2.*'
			},
			'rafamadriz/friendly-snippets',
			'onsails/lspkind.nvim',
		},

		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			require('luasnip.loaders.from_vscode').lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				}),
			})

			vim.cmd([[
      set completeopt=menuone,noinsert,noselect
      highlight! default link CmpItemKind CmpItemMenuDefault
      ]])
		end,
	},


	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup()
		end,
	},

	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()

			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"pyright", -- Python
					"clangd", -- C
					"solargraph", -- Ruby
					"texlab", -- LaTeX
					"lua_ls", -- Lua
					"html",  -- HTML
					"cssls", -- CSS
					"ts_ls"  -- JavaScript and TypeScript
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"black", -- Python formatter
					"pylint", -- Python linter
					"rubocop",
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local nvim_lsp = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local on_attach = function(client, bufnr)
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("Format", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format()
						end,
					})
				end
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			mason_lspconfig.setup_handlers({
				function(server)
					nvim_lsp[server].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["clangd"] = function()
					nvim_lsp["clangd"].setup({
						on_attach = function(client, bufnr)
							client.server_capabilities.documentFormattingProvider = false -- Disable formatting
							on_attach(client, bufnr)
						end,
						capabilities = capabilities,
						cmd = { 'clangd', '--header-insertion=never' },
						rootDir = function(fname)
							return nvim_lsp.util.root_pattern('.clangd', '.git')(fname)
									or nvim_lsp.util.path.dirname(fname)
						end,
					})
				end,
				["pyright"] = function()
					nvim_lsp["pyright"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["solargraph"] = function()
					nvim_lsp["solargraph"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["texlab"] = function()
					nvim_lsp["texlab"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				['lua_ls'] = function()
					nvim_lsp['lua_ls'].setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									version = 'LuaJIT',
								},
								diagnostics = {
									globals = { 'vim' },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file('', true),
								},
							},
						},
					})
				end,
				["html"] = function()
					nvim_lsp["html"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["cssls"] = function()
					nvim_lsp["cssls"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["ts_ls"] = function()
					nvim_lsp["ts_ls"].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		"nvim-neorg/neorg",
		ft = "norg",
		after = "nvim-treesitter",
		config = function()
			require('neorg').setup {
				load = {
					["core.defaults"] = {}, -- Load all default modules
				}
			}
		end
	},


	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier.with({
						filetypes = { "html", "css", "javascript", "typescript", "json" },
					}),
				},
			})
		end,
	},

	{
		"dhruvasagar/vim-table-mode",
		event = "BufReadPre",
		config = function()
			vim.g.table_mode_corner = '|'
		end
	}
})
