local telescope = require('telescope.builtin')
local tabs = require('telescope-tabs')

vim.api.nvim_set_keymap("n", "<C-P>",
  ":Telescope find_files find_command=rg,--no-ignore-vcs,--no-ignore-dot,--hidden,-g,!.git/*,-g,!node_modules/*,-g,!target/*,-g,!.clj-kondo,--files<Enter>",
  { noremap = true, silent = true })

vim.keymap.set('n', '<C-B>', telescope.buffers, {})
vim.keymap.set('n', '<C-F>', telescope.live_grep, {})
vim.keymap.set('n', '<C-D>', tabs.list_tabs, {})
