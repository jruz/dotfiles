require("oil").setup({
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
    ["<Space>ol"] = "actions.refresh",
    ["<Space>o_"] = "actions.open_cwd",
    ["<Space>o`"] = "actions.cd",
    ["<Space>o~"] = "actions.tcd",
  },
  view_options = {
    show_hidden = true,
  },
})

vim.api.nvim_set_keymap('n', '<C-f>', ':lua require("oil").open_float()<CR>', { noremap = true, silent = true })
