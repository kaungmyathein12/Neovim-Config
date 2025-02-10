-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- basic keymapping
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = true

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" }, 
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {"ts_ls","eslint"}
				})
			end
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason-lspconfig.nvim" },
			config = function()
				local lspconfig = require("lspconfig")
				lspconfig.ts_ls.setup({
					settings = {
						typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
						javascript = { inlayHints = { includeInlayParameterNameHints = "all" } }
					}
				})
				lspconfig.eslint.setup({
					setting = {
						format = true
					}
				})
			end
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",  
				"hrsh7th/cmp-buffer",    
				"hrsh7th/cmp-path",      
				"hrsh7th/cmp-nvim-lsp-signature-help"
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					mapping = cmp.mapping.preset.insert({
						["<CR>"] = cmp.mapping.confirm({ select = true }), 
						["<C-Space>"] = cmp.mapping.complete(), 					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp", priority = 1000 }, 
						{ name = "buffer", priority = 750 },    						
						{ name = "path", priority = 500 },      
					}),
					sorting = {
						comparators = {
							cmp.config.compare.offset,
							cmp.config.compare.exact,
							cmp.config.compare.score,
							cmp.config.compare.sort_text,
							cmp.config.compare.length,
							cmp.config.compare.order,
							cmp.config.compare.kind,   						
						}
					}
				})
			end
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "javascript", "typescript", "tsx", "json", "lua" },
					highlight = { enable = true },
					indent = { enable = true }
				})
			end
		},
		{"prettier/vim-prettier"},
		-- theme
		-- {
		-- 	'projekt0n/github-nvim-theme',
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	config = function()
		-- 		vim.cmd([[colorscheme github_dark_default]])
		-- 	end
		-- },
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("tokyonight-night")
			end
		},
		-- -- telescope
		{
			'nvim-telescope/telescope.nvim', tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' },
			keys = {
				{
					'<leader><leader>',
					function()
						require('telescope.builtin').find_files()
					end,
					desc = "Telescope find files"
				},		
				{
					'<leader>fg',
					function()
						require('telescope.builtin').live_grep()
					end,
					desc = "Telescope live grep"
				},
				{
					'<leader>fb',
					function()
						require('telescope.builtin').buffers()
					end,
					desc = "Telescope buffers"
				},
				{
					'<leader>fh',
					function()
						require('telescope.builtin').help_tags()
					end,
					desc = "Telescope help tags"
				}

			},
		},
	},
	checker = { enabled = true },
	install = {colorscheme = {"github_dark_default"}},
})
