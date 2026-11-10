require("conform").setup({
  formatters = {
    oxfmt = {
      command = "oxfmt",
    },
  },
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
    nu = { "nufmt" },
  },
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 2000,
      lsp_format = "fallback",
    }
  end,
})
