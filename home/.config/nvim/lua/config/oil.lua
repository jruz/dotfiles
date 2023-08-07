local oil = require("oil")

oil.setup({
  keymaps = {
    ["<Space>o?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<Space>os"] = "actions.select_vsplit",
    ["<Space>oi"] = "actions.select_split",
    ["<Space>op"] = "actions.preview",
    ["<Space>o-"] = "actions.parent",
    ["<Space>oh"] = "actions.toggle_hidden",
    ["<Space>ot"] = "actions.select_tab",
    ["<Space>oq"] = "actions.close",
    ["<Space>or"] = "actions.refresh",
    ["<Space>o_"] = "actions.open_cwd",
    ["<Space>o`"] = "actions.cd",
    ["<Space>o~"] = "actions.tcd",
  },
  view_options = {
    show_hidden = true,
  },
})

--vim.keymap.set('n', '<C-o>', oil.open_float, {})
