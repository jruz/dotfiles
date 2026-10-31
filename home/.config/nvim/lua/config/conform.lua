vim.keymap.set("n", "<space>lf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end)

require("conform").setup({
  formatters_by_ft = {
    css = { "oxfmt" },
    html = { "oxfmt" },
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    json = { "oxfmt" },
    just = { "just" },
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
