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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

vim.lsp.enable('clojure_lsp')
vim.lsp.enable('bashls')

vim.lsp.enable('biome')

vim.lsp.config('ts_ls', {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
vim.lsp.enable('ts_ls')

vim.lsp.enable('terraformls')
vim.lsp.enable('tflint')

vim.lsp.config('rust_analyzer', {
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
vim.lsp.enable('rust_analyzer')

vim.lsp.enable('rnix')
vim.lsp.enable('sourcekit')
vim.lsp.enable('rescriptls')

vim.lsp.enable('pylyzer')


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
