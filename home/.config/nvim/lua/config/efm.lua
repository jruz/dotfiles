local lspformat = require("lsp-format")

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

local prettier = {
  formatCommand = mason_bin .. "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

local clojure = {
  formatCommand = [[joker --format --stdin]],
  formatStdin = true,
}

local selene = {
  lintCommand = "selene --display-style quiet ${INPUT}",
  lintStdin = false,
  lintFormats = { "%f:%l:%c: %trror%m", "%f:%l:%c: %tarning%m" },
  rootMarkers = { "selene.toml" },
}

local stylua = {
  formatCommand = "stylua --search-parent-directories -",
  formatStdin = true,
  rootMarkers = { "stylua.toml", ".stylua.toml" },
}

vim.lsp.config('efm', {
  on_attach = lspformat.on_attach,
  init_options = { documentFormatting = true },
  settings = {
    languages = {
      html = { prettier },
      markdown = { prettier },
      svelte = { prettier },
      yaml = { prettier },
      clojure = { clojure },
      lua = { selene, stylua },
    },
  },
})
vim.lsp.enable('efm')
