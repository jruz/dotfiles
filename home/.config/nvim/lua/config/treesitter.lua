local parsers_install_dir = "~/.config/nvim-treesitter"
vim.opt.runtimepath:append(parsers_install_dir)

require("nvim-treesitter").setup({
  ensure_installed = {
    "bash",
    "c",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "nushell",
    "python",
    "query",
    "rescript",
    "rust",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },

  sync_install = true,
  auto_install = true,
  parser_install_dir = parsers_install_dir,
  ignore_install = { "" },

  highlight = {
    enable = true,

    -- disable slow treesitter highlight for large files
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = {},
  },
})
