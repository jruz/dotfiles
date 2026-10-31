require("conform").setup({
  formatters_by_ft = {
    css = { "oxfmt" },
    html = { "oxfmt" },
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    json = { "oxfmt" },
    markdown = { "oxfmt" },
    svelte = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    yaml = { "oxfmt" },
    clojure = { "joker" },
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})
