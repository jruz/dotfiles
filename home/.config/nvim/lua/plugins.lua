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
  { "catppuccin/nvim",        name = "catppuccin" },
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<C-r>"] = "refresh",
          ["<cr>"] = "open",
          ["<2-LeftMouse>"] = "open",
          ["<LeftRelease>"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              state.commands.toggle_node(state)
            else
              state.commands.open(state)
            end
          end,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          local events = require("neo-tree.events")
          events.fire_event(events.GIT_EVENT)
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "▌" },
        untracked = { text = "▌" },
      },
    },
  },
  "osyo-manga/vim-over",
  { "folke/ts-comments.nvim", opts = {},          event = "VeryLazy" },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
    },
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
      vim.g.VM_mouse_mappings = 0
      vim.g.VM_silent_exit = 1
      vim.g.VM_show_warnings = 0
      vim.g.VM_set_statusline = 0
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = { char = "▏", highlight = "IblIndent" },
      scope = { char = "▎", highlight = "IblScope" },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#585b70" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#6c7086" })
      require("ibl").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = false,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline",
      },
      messages = {
        view_search = false,
      },
      lsp = {
        progress = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require('render-markdown').setup({
      heading = { sign = false, position = "inline", backgrounds = {}, icons = {} },
      code = {
        enabled = true,
        style = 'full',
        left_pad = 0,
        right_pad = 0,
        inline = false,
      },
      bullet = {
        enabled = false,
      },
      checkbox = {
        enabled = false,
      },
      quote = {
        enabled = false,
      },
      })
      vim.opt.conceallevel = 0
    end,
  },
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
    opts = {
      preset = "modern",
      delay = 300,
      expand = 1,
      icons = {
        mappings = false,
        separator = "->",
      },
    }
  },
  {
    "LukasPietzschmann/telescope-tabs",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope-tabs").setup({})
    end,
  },

  -- Lua
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip/loaders/from_vscode").load()
    end,
  },

  -- ReScript
  "rescript-lang/vim-rescript",
  {
    "aspeddro/rescript-tools.nvim",
    ft = "rescript",
  },

  -- Rust
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        ignore_filetypes = {
          sh = true,
          dotenv = true,
        },
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.g.SUPERMAVEN_DISABLED = 0
          local api = require("supermaven-nvim.api")
          if not api.is_running() then
            api.start()
          end
        end,
      })
    end,
  },

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
  { "j-hui/fidget.nvim",  tag = "legacy" },
  { "folke/lazydev.nvim", ft = "lua",    opts = {} },
  "mfussenegger/nvim-dap",
  "neovim/nvim-lspconfig",
  {
    "folke/trouble.nvim",
    config = function()
      local trouble = require("trouble")

      trouble.setup({
        auto_close = true,
        auto_open = false,
      })

      vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ft = vim.bo[bufnr].filetype
          local bt = vim.bo[bufnr].buftype

          local ignored_filetypes = { "lazy", "mason", "trouble", "TelescopePrompt", "qf" }
          for _, ignored in ipairs(ignored_filetypes) do
            if ft == ignored then
              return
            end
          end

          if bt ~= "" then
            return
          end

          local diagnostics = vim.diagnostic.get(bufnr)

          if #diagnostics > 0 then
            trouble.open({ mode = "diagnostics", filter = { buf = bufnr }, focus = false })
          else
            if trouble.is_open() then
              trouble.close()
            end
          end
        end,
      })
    end,
  },
  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require('lsp-format').setup({})
    end,
  },
  {
    "jannis-baum/vivify.vim",
    ft = { "markdown" },
  },
}

local opts = {
  root = vim.fn.stdpath("data") .. "/lazy",
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
}

require("lazy").setup(plugins, opts)

vim.cmd([[command! PluginsConfig :edit ~/.config/nvim/lua/plugins.lua]])
