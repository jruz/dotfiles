require("neodev").setup({})
require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "deno",
    "efm",
    "eslint-lsp",
    "lua-language-server",
    "rescript-lsp",
    "rnix-lsp",
    "rome",
    "rust-analyzer",
    "rustfmt",
    "terraform-ls",
    "tflint",
    "tfsec",
    "typescript-language-server",
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
lspconfig.eslint.setup({})
lspconfig.tsserver.setup({})
--lspconfig.denols.setup({})
lspconfig.rome.setup({
  capabilities = capabilities,
})
lspconfig.terraformls.setup({})
lspconfig.tflint.setup({})
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})
lspconfig.rnix.setup({})
lspconfig.sourcekit.setup({})
lspconfig.rescriptls.setup({
  capabilities = capabilities,
  cmd = {
    'node',
    "/home/jruz/.local/share/nvim/mason/packages/rescript-lsp/extension/server/out/server.js",
    '--stdio',
  }
})

-- EFM
local prettier = {
  formatCommand = [[prettier --stdin-filepath ${INPUT}]],
  formatStdin = true,
}
require("lsp-format").setup({})
lspconfig.efm.setup({
  on_attach = require("lsp-format").on_attach,
  init_options = { documentFormatting = true },
  settings = {
    languages = {
      css = { prettier },
      html = { prettier },
      javascript = { prettier },
      json = { prettier },
      markdown = { prettier },
      typescript = { prettier },
      yaml = { prettier },
    },
  },
})


vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "dataviewjs=javascript"
}

-- Fix for Rome
require("vim.lsp._watchfiles")._watchfunc = function()
  return function() end
end

require("fidget").setup({})
require("trouble").setup({})

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
