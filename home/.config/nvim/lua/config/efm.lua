local lspformat = require("lsp-format")

local function prettier_cmd()
  local root = vim.fn.getcwd()
  local local_prettier = root .. "/node_modules/.bin/prettier"
  if vim.fn.executable(local_prettier) == 1 then
    return local_prettier
  end
  return "prettier"
end

local prettier = {
  formatCommand = prettier_cmd() .. " --stdin-filepath ${INPUT}",
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
      css = { prettier },
      html = { prettier },
      javascript = { prettier },
      javascriptreact = { prettier },
      json = { prettier },
      markdown = { prettier },
      svelte = { prettier },
      typescript = { prettier },
      typescriptreact = { prettier },
      yaml = { prettier },
      clojure = { clojure },
      lua = { selene, stylua },
    },
  },
})
vim.lsp.enable('efm')
