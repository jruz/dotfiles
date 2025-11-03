local trouble = require("trouble")

trouble.setup({
  auto_close = true,
  auto_open = false,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)

    if #diagnostics > 0 then
      trouble.open({ mode = "diagnostics", filter = { buf = bufnr }, focus = false })
    else
      if trouble.is_open() then
        trouble.close()
      end
    end
  end,
})
