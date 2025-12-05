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
    },
  },
})
vim.lsp.enable('efm')
