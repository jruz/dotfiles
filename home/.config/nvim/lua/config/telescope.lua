-- Keyboard Shortcuts
vim.api.nvim_set_keymap("n", "<C-P>",
  ":Telescope find_files find_command=rg,--no-ignore-dot,--hidden,-g,!.git/,--files<Enter>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-B>", ":Telescope buffers<Enter>", { noremap = true })
