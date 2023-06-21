-- Package Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local function word_count()
        local file_extension = vim.fn.expand('%:e')
        if file_extension == 'txt' then
          local current_word_count = vim.fn.wordcount().words
          return string.format('%d words', current_word_count)
        else
          return ''
        end
      end

      require("lualine").setup({
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics', word_count },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end
  },
  "tpope/vim-fugitive",
  'NoahTheDuke/vim-just',
  "github/copilot.vim",
  "preservim/nerdtree",
  "ryanoasis/vim-devicons",
  "airblade/vim-gitgutter",
  "osyo-manga/vim-over",
  "preservim/nerdcommenter",
  "nvim-treesitter/nvim-treesitter",
  "nvim-tree/nvim-web-devicons",

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "j-hui/fidget.nvim",
  "folke/neodev.nvim",
  "mfussenegger/nvim-dap",
  "neovim/nvim-lspconfig",
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        auto_open = true,
        auto_close = true,
      })
    end
  },
}

local opts = {
  root = vim.fn.stdpath("data") .. "/lazy",
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
}

require("lazy").setup(plugins, opts)

vim.cmd([[command Plugins :edit ~/.config/nvim/lua/plugins.lua]])
