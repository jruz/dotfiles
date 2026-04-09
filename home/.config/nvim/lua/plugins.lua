-- Pre-plugin settings (must be set before plugins load)
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
}
vim.g.VM_mouse_mappings = 0
vim.g.VM_silent_exit = 1
vim.g.VM_show_warnings = 0
vim.g.VM_set_statusline = 0

vim.o.timeout = true
vim.o.timeoutlen = 300

-- Hooks (must be created before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
    if not ev.data.active then
      vim.cmd.packadd('nvim-treesitter')
    end
    vim.cmd('TSUpdate')
  end
end })

-- All plugins (dependencies listed before dependents)
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/echasnovski/mini.icons',
  'https://github.com/MunifTanjim/nui.nvim',

  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },

  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/LukasPietzschmann/telescope-tabs',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/folke/which-key.nvim',
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },

  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/mg979/vim-visual-multi',
  'https://github.com/echasnovski/mini.surround',
  'https://github.com/folke/ts-comments.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/osyo-manga/vim-over',

  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/folke/noice.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',

  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/L3MON4D3/LuaSnip',

  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-cmdline',
  'https://github.com/hrsh7th/cmp-nvim-lua',
  'https://github.com/hrsh7th/cmp-omni',
  'https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol',
  'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',

  'https://github.com/NoahTheDuke/vim-just',
  'https://github.com/rescript-lang/vim-rescript',
  'https://github.com/aspeddro/rescript-tools.nvim',
  'https://github.com/saecki/crates.nvim',
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range('5.x') },

  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/j-hui/fidget.nvim', version = 'legacy' },
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/lukas-reineke/lsp-format.nvim',

  'https://github.com/supermaven-inc/supermaven-nvim',

  'https://github.com/jannis-baum/vivify.vim',
})

-- Plugin configurations

require("mini.icons").setup()
require("nvim-autopairs").setup()

require("gitsigns").setup({
  signs = {
    add = { text = "▌" },
    change = { text = "▌" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "▌" },
    untracked = { text = "▌" },
  },
})

require("neo-tree").setup({
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
})
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local events = require("neo-tree.events")
    events.fire_event(events.GIT_EVENT)
  end,
})

require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    replace = "gsr",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    update_n_lines = "gsn",
  },
})

require("ts-comments").setup({})
require("todo-comments").setup({})

vim.api.nvim_set_hl(0, "IblIndent", { fg = "#585b70" })
vim.api.nvim_set_hl(0, "IblScope", { fg = "#6c7086" })
require("ibl").setup({
  indent = { char = "▏", highlight = "IblIndent" },
  scope = { char = "▎", highlight = "IblScope" },
})

require("notify").setup({ top_down = false })

require("noice").setup({
  cmdline = { view = "cmdline" },
  messages = { view_search = false },
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
})

require("render-markdown").setup({
  heading = { sign = false, position = "inline", backgrounds = {}, icons = {} },
  code = {
    enabled = true,
    style = 'full',
    left_pad = 0,
    right_pad = 0,
    inline = false,
  },
  bullet = { enabled = false },
  checkbox = { enabled = false },
  quote = { enabled = false },
})
vim.opt.conceallevel = 0

local install_dir = vim.fn.expand("~/.local/share/nvim/treesitter")
require("nvim-treesitter").setup({ install_dir = install_dir })
local parsers = {
  "bash", "c", "clojure", "css", "gleam", "glsl", "html",
  "javascript", "json", "lua", "python", "query",
  "regex", "rust", "toml", "typescript", "vim", "vimdoc", "yaml",
}
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local ts = require("nvim-treesitter")
    local installed = ts.get_installed()
    local is_installed = vim.tbl_contains(installed, lang)
    if is_installed then
      pcall(vim.treesitter.start, bufnr)
    else
      local available = ts.get_available()
      if vim.tbl_contains(available, lang) then
        ts.install(lang):wait(60000)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            pcall(vim.treesitter.start, bufnr)
          end
        end)
      end
    end
  end,
})

require("which-key").setup({
  preset = "modern",
  delay = 300,
  expand = 1,
  icons = {
    mappings = false,
    separator = "->",
  },
})

require("telescope-tabs").setup({})

require("luasnip/loaders/from_vscode").load()

require("crates").setup()
require("lazydev").setup({})
require("lsp-format").setup({})

require("trouble").setup({
  auto_close = true,
  auto_open = false,
})
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype
    local ignored_filetypes = { "trouble", "TelescopePrompt", "qf" }
    for _, ignored in ipairs(ignored_filetypes) do
      if ft == ignored then return end
    end
    if bt ~= "" then return end
    local diagnostics = vim.diagnostic.get(bufnr)
    local trouble = require("trouble")
    if #diagnostics > 0 then
      trouble.open({ mode = "diagnostics", filter = { buf = bufnr }, focus = false })
    else
      if trouble.is_open() then
        trouble.close()
      end
    end
  end,
})

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

vim.cmd([[command! PluginsConfig :edit ~/.config/nvim/lua/plugins.lua]])
