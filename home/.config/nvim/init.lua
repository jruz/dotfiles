-- Base Config
vim.o.compatible = false
vim.o.encoding = "utf-8"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.g.indentLine_char = "│"
vim.g.mapleader = ","
vim.wo.number = true
vim.o.autoread = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.cmd([[syntax on]])
vim.o.mouse = ""

-- Package Manager
require("plugins")

-- Active Theme
vim.cmd.colorscheme("catppuccin-mocha")

-- Commands
vim.cmd([[command Config :edit ~/.config/nvim/init.lua]])
vim.cmd([[command Wq :wq]])

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

-- Cursorline only on active window
vim.cmd([[augroup CursorLineOnlyInActiveWindow]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline]])
vim.cmd([[autocmd WinLeave * setlocal nocursorline]])
vim.cmd([[augroup END]])

-- Line length marker
vim.cmd([[highlight ColorColumn ctermbg=magenta]])
vim.cmd([[call matchadd('ColorColumn', '\\%81v', 80)]])

-- Plugins
require("config.lsp")
require("config.wordcount")
require("config.treesitter")
require("config.telescope")
