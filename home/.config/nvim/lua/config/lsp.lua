-- LSP servers installed via Nix (home-manager)

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

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

vim.lsp.config('eslint', {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
      'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
      'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
    })
    if root then
      on_dir(root)
    end
  end,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  single_file_support = false,
})
vim.lsp.enable('eslint')

vim.lsp.config('denols', {
  root_dir = function(bufnr, on_dir)
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    if deno_root then
      on_dir(deno_root)
    end
  end,
  single_file_support = false,
})

vim.lsp.config('ts_ls', {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  root_dir = function(bufnr, on_dir)
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    if deno_root then
      return
    end
    local ts_root = vim.fs.root(bufnr, { 'package.json' })
    if ts_root then
      on_dir(ts_root)
    end
  end,
  single_file_support = false,
})

vim.lsp.enable('denols')
vim.lsp.enable('ts_ls')

vim.lsp.enable('terraformls')
vim.lsp.enable('tflint')

vim.lsp.config('jsonls', {
  init_options = {
    provideFormatter = false
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
vim.lsp.enable('jsonls')
vim.lsp.enable('cssls')
vim.lsp.enable('html')
vim.lsp.enable('nixd')
vim.lsp.enable('sourcekit')
-- vim.lsp.enable('rescriptls') -- not in nixpkgs, install via npm if needed

vim.lsp.enable('pylyzer')

vim.lsp.enable('gleam')
vim.lsp.enable('nushell')

-- Markdown
vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "dataviewjs=javascript"
}

require("fidget").setup({})

-- Keybindings
vim.keymap.set('n', '<space>le', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1 })
end)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1 })
end)
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
    vim.keymap.set('n', '<space>ld', vim.lsp.buf.definition, opts)
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
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, opts)
  end,
})

vim.cmd([[command! LSPConfig :edit ~/.config/nvim/lua/config/lsp.lua]])
