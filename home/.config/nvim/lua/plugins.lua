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
  { "catppuccin/nvim",   name = "catppuccin" },
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
  "nvim-lualine/lualine.nvim",
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
  "stevearc/oil.nvim",
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  --{
  --"jackMort/ChatGPT.nvim",
  --event = "VeryLazy",
  --config = function()
  --require("chatgpt").setup({
  --openai_params = {
  --model = "gpt-4",
  --max_tokens = 8000,
  --},
  --})
  --end,
  --dependencies = {
  --"MunifTanjim/nui.nvim",
  --"nvim-lua/plenary.nvim",
  --"nvim-telescope/telescope.nvim"
  --}
  --},
  -- Lua
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip/loaders/from_vscode").load()
    end,
  },
  -- ReScript
  --{
  --"nkrkv/nvim-treesitter-rescript",
  --dependencies = { "nvim-treesitter/nvim-treesitter" },
  --},
  "rescript-lang/vim-rescript",
  -- Rust
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },
  --{
  --"simrat39/rust-tools.nvim",
  --requires = {
  --"nvim-lua/plenary.nvim",
  --"mfussenegger/nvim-dap",
  --},
  --config = function()
  --local rt = require("rust-tools")
  --rt.setup({
  --server = {
  --on_attach = function(_, bufnr)
  ---- Hover actions
  --vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
  ---- Code action groups
  --vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
  --end,
  --},
  --})
  --rt.hover_actions.hover_actions()
  --end
  --},

  -- Deno
  --{
  --"sigmasd/deno-nvim",
  --config = function()
  --require("deno-nvim").setup()
  --end
  --},

  -- Completion
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-omni',
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  'hrsh7th/cmp-nvim-lsp-signature-help',


  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  { "j-hui/fidget.nvim", tag = "legacy" },
  "folke/neodev.nvim",
  "mfussenegger/nvim-dap",
  "neovim/nvim-lspconfig",
  "lukas-reineke/lsp-format.nvim",
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

vim.cmd([[command PluginsConfig :edit ~/.config/nvim/lua/plugins.lua]])
