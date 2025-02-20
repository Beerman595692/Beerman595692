vim.cmd("set relativenumber number")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
	{"ThePrimeagen/vim-be-good"},
	{ 'echasnovski/mini.nvim', version = false },
	{
		'nvim-telescope/telescope.nvim', tag = '1.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{"Beerman595692/reddish.nvim", name = "reddish", priority = 1000},
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
	{"nvim-treesitter/nvim-treesitter", build= ":TSUpdate"},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},
	{
		"olrtg/nvim-emmet",
		config = function()
			vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
		end,
	},
	{
    		'MeanderingProgrammer/render-markdown.nvim',
    		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    		---@module 'render-markdown'
    		---@type render.md.UserConfig
    		opts = {},
	}
}
	
require("lazy").setup(plugins, opts)
--Mini Setup
require('mini.ai').setup()
require('mini.completion').setup()
require('mini.files').setup()
require('mini.icons').setup()
require('mini.git').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.colors').setup()

require("gruvbox").setup({
    overrides = {
        Normal = {fg = "#f6c2a5"}
    }
})

local builtin = require("telescope.builtin")
vim.keymap.set('n','<C-p>', builtin.find_files,{})
vim.keymap.set('n','<leader>fg', builtin.live_grep,{})
vim.keymap.set('n','<leader>fi',':lua MiniFiles.open()')

local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "javascript","python","markdown","c","markdown_inline","html","css","json"},
  highlight = { enable = true },
  indent = { enable = true }
})
vim.cmd("colorscheme gruvbox")

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
