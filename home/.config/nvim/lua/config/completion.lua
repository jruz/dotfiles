local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "enter",
    ["<C-j>"] = { "scroll_documentation_up", "fallback" },
    ["<C-k>"] = { "scroll_documentation_down", "fallback" },
  },
  snippets = {
    preset = "default",
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 300,
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "omni" },
  },
  cmdline = {
    keymap = {
      preset = "cmdline",
      ["<CR>"] = { "accept_and_enter", "fallback" },
    },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  signature = {
    enabled = true,
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
})
