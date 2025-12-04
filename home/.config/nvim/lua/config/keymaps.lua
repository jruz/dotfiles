-- Remove arrow keys
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
vim.api.nvim_set_keymap("n", "<M-j>", ":m .+1<CR>==", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-k>", ":m .-2<CR>==", { noremap = true })

-- Tabs
vim.api.nvim_set_keymap("n", "<A-T>", ":tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<A-[>", ":tabprev<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<A-]>', ':tabnext<CR>', { noremap = true })

-- Save with ctrl-s
vim.api.nvim_set_keymap('i', '<C-S>', '<Esc>:update<CR>gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S>', ':update<CR>', { noremap = true, silent = true })

-- Neo-tree
vim.api.nvim_set_keymap("n", "<C-T>", ":Neotree toggle reveal<CR>", { noremap = true, silent = true })

-- Undo/Redo
vim.keymap.set({ 'n', 'i', 'v' }, '<C-z>', '<Cmd>undo<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-S-z>', '<Cmd>redo<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-y>', '<Cmd>redo<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'U', '<Cmd>redo<CR>', { noremap = true, silent = true })

-- Reload file from disk
vim.keymap.set('n', '<C-r>', '<Cmd>checktime<CR>', { noremap = true, silent = true })

-- Scroll half page
vim.keymap.set({ 'n', 'v' }, '<C-Down>', '<C-d>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-Up>', '<C-u>', { noremap = true, silent = true })

-- Command palette with Cmd+Shift+P
vim.keymap.set('n', '<C-S-p>', '<cmd>Telescope commands<cr>', { silent = true })
vim.keymap.set('n', '\x1b[80;6u', '<cmd>Telescope commands<cr>', { silent = true })

-- Toggle comment with Ctrl+/
vim.keymap.set({ 'n', 'i' }, '<C-_>', 'gcc', { remap = true, silent = true })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, silent = true })

-- Copy and paste to system clipboard
vim.api.nvim_set_keymap('n', 'yy', '"+yy', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'D', '"+D', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'dd', '"+dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'd', '"+d', { noremap = true, silent = true })
