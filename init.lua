vim.wo.number = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = true
vim.o.background = 'dark'
vim.wo.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = 'unnamedplus'

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove("c") -- prevents commenting empty lines
        vim.opt.formatoptions:remove("r") -- prevents auto-commenting on new lines
    end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.opt.commentstring = "// %s"  -- Add a space after `//`
  end
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ 
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "folke/tokyonight.nvim" },
   	{ "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" },
})

require("nvim-treesitter.configs").setup({
    -- ensure_installed = { "javascript", "typescript", "html", "css" },
    highlight = { enable = true },
	indent = {
		enable = false 
	},
})

require("tokyonight").setup({
    styles = {
        keywords = { italic = false },
    },
	on_highlights = function(hl, colors)
		hl["@keyword"] = { fg = "#edc0d6" }
		hl["@variable"] = { fg = "#fcf1ea" }
		hl["@variable.builtin"] = { fg = "#d66060", bold = true }
	end
})

vim.cmd[[colorscheme tokyonight-night]]

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
		"intelephense"
    },
})

require("lspconfig").intelephense.setup({
	settings = {
		intelephense = {
			format = {
				braces = "psr12",
				enable = true
			}
		}
	}
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.phpcsfixer.with({
			extra_args = { "--rules=@PSR12", "--using-cache=no" }
		}),
		null_ls.builtins.diagnostics.phpcs.with({
			extra_args = { "--standard=PSR12" }
		})
	}
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.php",
-- 	callback = function()
-- 		vim.lsp.buf.format()
-- 	end
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
    vim.bo.softtabstop = 4
	vim.bo.autoindent = true
    vim.bo.smartindent = true
	vim.bo.cindent = true
	vim.bo.copyindent = true
  end
})
