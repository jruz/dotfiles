-- format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
null_ls.setup({
	debug = true,
	sources = {
		formatting.stylua,
		formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
		formatting.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		diagnostics.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		code_actions.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
	},

	-- format on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
