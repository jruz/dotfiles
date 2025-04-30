require("neodev").setup({})
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "clojure_lsp",
    "denols",
    "efm",
    "eslint",
    "lua_ls",
    "pylyzer",
    "rescriptls",
    "rnix",
    "biome",
    "rust_analyzer",
    "terraformls",
    "tflint",
    "ts_ls",
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "clj-kondo",
    "joker",
    "shfmt",
    "tfsec",
  },
  auto_update = true,
  run_on_start = true,
})

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
lspconfig.clojure_lsp.setup({})
lspconfig.bashls.setup({})
-- lspconfig.eslint.setup({
--   on_attach = function(_client, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--   end,
-- })
lspconfig.biome.setup {}
lspconfig.ts_ls.setup({
  on_attach = function(client)
    -- disable formatting so it uses biome
    client.server_capabilities.documentFormattingProvider = false
  end,
})
lspconfig.ts_ls.setup({})
--lspconfig.denols.setup({})
lspconfig.terraformls.setup({})
lspconfig.tflint.setup({})
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
        extraArgs = {
          "-- -W clippy::pedantic -D clippy::unwrap_used",
        },
      },
      checkOnSave = true,
    },
  },
})
lspconfig.rnix.setup({})
lspconfig.sourcekit.setup({})
lspconfig.rescriptls.setup({})

-- Python
lspconfig.pylyzer.setup({})


-- Markdown
vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "dataviewjs=javascript"
}

require("fidget").setup({})

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Keybindings
vim.keymap.set('n', '<space>le', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>lq', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<space>lD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<space>ld', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>li', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>lh', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>lwd', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>lt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>ln', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.cmd([[command LSPConfig :edit ~/.config/nvim/lua/config/lsp.lua]])
