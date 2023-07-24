-- Hard mode
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", { noremap = true })

-- Split navigation with ctrl
vim.api.nvim_set_keymap("n", "<C-J>", "<C-W><C-J>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-K>", "<C-W><C-K>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-L>", "<C-W><C-L>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-H>", "<C-W><C-H>", { noremap = true })

-- Move lines
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true })
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true })
