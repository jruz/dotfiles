local lspformat = require("lsp-format")

local prettier = {
  formatCommand = [[./node_modules/prettier/bin/prettier.cjs --format ${INPUT}]],
  formatStdin = true,
}

local rustfmt = {
  formatCommand = "[[rustfmt ${INPUT} --emit=stdout --edition=2021]]",
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
      css = { prettier },
      html = { prettier },
      javascript = { prettier },
      json = { prettier },
      markdown = { prettier },
      svelte = { prettier },
      clojure = { clojure },
      yaml = { prettier },
    },
  },
})
vim.lsp.enable('efm')
