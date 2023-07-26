local lspformat = require("lsp-format").setup({})
local lspconfig = require("lspconfig")

local prettier = {
  formatCommand = [[prettierd ${INPUT}]],
  formatStdin = true,
}

local rustfmt = {
  formatCommand = "[[rustfmt ${INPUT} --emit=stdout --edition=2021]]",
  formatStdin = true,
}

lspconfig.efm.setup({
  on_attach = lspformat.on_attach,
  init_options = { documentFormatting = true },
  settings = {
    languages = {
      css = { prettier },
      html = { prettier },
      javascript = { prettier },
      json = { prettier },
      markdown = { prettier },
      rust = { rustfmt },
      toml = { rustfmt },
      typescript = { prettier },
      yaml = { prettier },
    },
  },
})
