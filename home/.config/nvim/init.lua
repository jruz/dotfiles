-- Base Config
vim.o.compatible = false
vim.o.encoding = "utf-8"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.wo.number = true
vim.o.signcolumn = "yes"
vim.o.autoread = true
vim.o.updatetime = 1000

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.syntax = "on"
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.smoothscroll = true

vim.filetype.add({
  pattern = {
    ['%.env'] = 'dotenv',
    ['%.env%..*'] = 'dotenv',
    ['.*%.env'] = 'dotenv',
  },
})
vim.treesitter.language.register('bash', 'dotenv')

-- Folding
vim.wo.foldmethod = "indent"
vim.wo.foldnestmax = 4
vim.wo.foldenable = false
vim.wo.foldlevel = 1

-- Rustaceanvim config must be set before plugin loads
vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      auto_focus = false,
    },
  },
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        check = {
          command = "clippy",
          extraArgs = {
            "-- -W clippy::pedantic -D clippy::unwrap_used",
          },
        },
        checkOnSave = true,
        procMacro = {
          enable = true,
        },
        inlayHints = {
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never",
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  },
}

-- Package Manager
require("plugins")

-- Active Theme
vim.cmd.colorscheme("catppuccin-mocha")

-- Commands
vim.cmd([[command! Config :edit ~/.config/nvim/init.lua]])
vim.cmd([[command! -bang Wq :wq<bang>]])
vim.cmd([[command! -bang Wqa :wqa<bang>]])
vim.cmd([[command! -bang Qa :qa<bang>]])

-- Auto Save
--vim.api.nvim_command('autocmd FocusLost * :wa')

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
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype
    if ft ~= "neo-tree" and bt == "" then
      vim.fn.matchadd('ExtraWhitespace', '\\s\\+$')
    end
  end,
})

-- Plugins Config
require("config")
