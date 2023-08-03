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
vim.o.syntax = "on"
vim.o.mouse = ""
vim.o.showmode = false

-- Folding
vim.wo.foldmethod = "indent"
vim.wo.foldnestmax = 4
vim.wo.foldenable = false
vim.wo.foldlevel = 1


-- Package Manager
require("plugins")

-- Active Theme
vim.cmd.colorscheme("catppuccin-mocha")

-- Commands
vim.cmd([[command Config :edit ~/.config/nvim/init.lua]])
vim.cmd([[command Wq :wq]])
vim.cmd([[command Wqa :wqa]])

-- Auto Save
vim.api.nvim_command('autocmd FocusLost * :wa')

-- Cursorline only on active window
vim.cmd([[augroup CursorLineOnlyInActiveWindow]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline]])
vim.cmd([[autocmd WinLeave * setlocal nocursorline]])
vim.cmd([[augroup END]])

-- Line length marker
vim.cmd([[highlight ColorColumn ctermbg=magenta]])
vim.cmd([[call matchadd('ColorColumn', '\\%81v', 80)]])
vim.cmd('highlight ExtraWhitespace guibg=#B4BEFE')
vim.cmd('autocmd BufWinEnter * match ExtraWhitespace /\\s\\+$/')

-- Plugins Config
require("config")
