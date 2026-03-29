-- Remove arrow keys
vim.api.nvim_set_keymap("n", "<Up>", "<C-b>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "<C-f>", { noremap = true })
vim.keymap.set("n", "<Left>", function()
  require('gitsigns').prev_hunk()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<Right>", function()
  require('gitsigns').next_hunk()
end, { noremap = true, silent = true })

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

-- Toggle comment with Ctrl+/
vim.keymap.set({ 'n', 'i' }, '<C-_>', 'gcc', { remap = true, silent = true })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, silent = true })


local function set_fold_level(level, nestmax)
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" then
    return
  end
  vim.wo.foldlevel = level
  vim.wo.foldnestmax = nestmax
end

vim.keymap.set('n', 'zz', 'za', { noremap = true, silent = true })
vim.keymap.set('n', 'z0', 'zR', { noremap = true, silent = true })
vim.keymap.set('n', 'z1', function()
  set_fold_level(0, 1)
end, { noremap = true, silent = true })
vim.keymap.set('n', 'z2', function()
  set_fold_level(1, 2)
end, { noremap = true, silent = true })
vim.keymap.set('n', 'z3', function()
  set_fold_level(2, 3)
end, { noremap = true, silent = true })
vim.keymap.set('n', 'z4', function()
  set_fold_level(3, 4)
end, { noremap = true, silent = true })
vim.keymap.set('n', 'z5', function()
  set_fold_level(4, 5)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>th', function()
  vim.opt.list = not vim.opt.list:get()
end, { noremap = true, silent = true, desc = "Toggle hidden characters" })

vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { noremap = true, silent = true })
vim.keymap.set('n', 'C', '"_C', { noremap = true, silent = true })
vim.keymap.set('n', 'cc', '"_cc', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 's', '"_s', { noremap = true, silent = true })
vim.keymap.set('n', 'S', '"_S', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { noremap = true, silent = true })
vim.keymap.set('n', 'X', '"_X', { noremap = true, silent = true })
