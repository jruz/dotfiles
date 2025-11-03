local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<space>ra", function()
  vim.cmd.RustLsp('codeAction')
end, { silent = true, buffer = bufnr, desc = "Rust Code Action" })

vim.keymap.set("n", "<space>rr", function()
  vim.cmd.RustLsp('runnables')
end, { silent = true, buffer = bufnr, desc = "Rust Runnables" })

vim.keymap.set("n", "<space>rd", function()
  vim.cmd.RustLsp('debuggables')
end, { silent = true, buffer = bufnr, desc = "Rust Debuggables" })

vim.keymap.set("n", "<space>rt", function()
  vim.cmd.RustLsp('testables')
end, { silent = true, buffer = bufnr, desc = "Rust Run Tests" })

vim.keymap.set("n", "<space>re", function()
  vim.cmd.RustLsp('expandMacro')
end, { silent = true, buffer = bufnr, desc = "Rust Expand Macro" })

vim.keymap.set("n", "<space>rm", function()
  vim.cmd.RustLsp('rebuildProcMacros')
end, { silent = true, buffer = bufnr, desc = "Rust Rebuild Proc Macros" })

vim.keymap.set("n", "<space>rp", function()
  vim.cmd.RustLsp('parentModule')
end, { silent = true, buffer = bufnr, desc = "Rust Parent Module" })

vim.keymap.set("n", "<space>rj", function()
  vim.cmd.RustLsp('joinLines')
end, { silent = true, buffer = bufnr, desc = "Rust Join Lines" })

vim.keymap.set("n", "<space>rc", function()
  vim.cmd.RustLsp('openCargo')
end, { silent = true, buffer = bufnr, desc = "Rust Open Cargo.toml" })

vim.keymap.set("n", "<space>rh", function()
  vim.cmd.RustLsp({ 'hover', 'actions' })
end, { silent = true, buffer = bufnr, desc = "Rust Hover Actions" })

vim.keymap.set("n", "<space>rx", function()
  vim.cmd.RustLsp('explainError')
end, { silent = true, buffer = bufnr, desc = "Rust Explain Error" })

vim.keymap.set("n", "<space>rR", function()
  vim.cmd.RustLsp('renderDiagnostic')
end, { silent = true, buffer = bufnr, desc = "Rust Render Diagnostic" })
