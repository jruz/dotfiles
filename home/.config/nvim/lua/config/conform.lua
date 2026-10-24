require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    clojure = { "joker" },
    lua = { "stylua" },
  },
  formatters = {
    prettier = { command = "prettier" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})
