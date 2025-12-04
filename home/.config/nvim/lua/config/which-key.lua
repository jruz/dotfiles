local wk = require("which-key")

wk.add({
  { "<space>f", group = "Find" },
  { "<space>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
  { "<space>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  { "<space>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<space>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
  { "<space>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<space>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<space>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<space>ft", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Tabs" },
})

wk.add({
  { "<space>l", group = "LSP" },
  { "<space>ld", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "<space>lD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
  { "<space>li", vim.lsp.buf.implementation, desc = "Go to Implementation" },
  { "<space>lr", vim.lsp.buf.references, desc = "References" },
  { "<space>lR", vim.lsp.buf.rename, desc = "Rename" },
  { "<space>lh", vim.lsp.buf.hover, desc = "Hover" },
  { "<space>ls", vim.lsp.buf.signature_help, desc = "Signature Help" },
  { "<space>la", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<space>lf", vim.lsp.buf.format, desc = "Format" },
  { "<space>lt", vim.lsp.buf.type_definition, desc = "Type Definition" },
  { "<space>lw", group = "Workspace" },
  { "<space>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" },
  { "<space>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" },
  { "<space>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List Folders" },
})

wk.add({
  { "<space>g", group = "Git" },
  { "<space>gs", "<cmd>Git<cr>", desc = "Status" },
  { "<space>gc", "<cmd>Git commit<cr>", desc = "Commit" },
  { "<space>gp", "<cmd>Git push<cr>", desc = "Push" },
  { "<space>gP", "<cmd>Git pull<cr>", desc = "Pull" },
  { "<space>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },
  { "<space>gB", "<cmd>Git blame<cr>", desc = "Blame File" },
  { "<space>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff" },
  { "<space>gl", "<cmd>Git log<cr>", desc = "Log" },
  { "<space>gh", group = "Hunks" },
  { "<space>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
  { "<space>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
  { "<space>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
  { "<space>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage" },
  { "<space>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
  { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
  { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
})

wk.add({
  { "<space>t", group = "Trouble" },
  { "<space>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Diagnostics" },
  { "<space>td", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
  { "<space>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
  { "<space>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions" },
  { "<space>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
  { "<space>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
})

wk.add({
  { "<space>w", group = "Window" },
  { "<space>wh", "<C-w>h", desc = "Go Left" },
  { "<space>wj", "<C-w>j", desc = "Go Down" },
  { "<space>wk", "<C-w>k", desc = "Go Up" },
  { "<space>wl", "<C-w>l", desc = "Go Right" },
  { "<space>ws", "<C-w>s", desc = "Split Horizontal" },
  { "<space>wv", "<C-w>v", desc = "Split Vertical" },
  { "<space>wq", "<C-w>q", desc = "Close Window" },
  { "<space>wo", "<C-w>o", desc = "Close Other Windows" },
})

wk.add({
  { "<space>n", group = "File Tree" },
  { "<space>nt", "<cmd>Neotree toggle<cr>", desc = "Toggle" },
  { "<space>nf", "<cmd>Neotree reveal<cr>", desc = "Find Current File" },
  { "<space>ng", "<cmd>Neotree git_status<cr>", desc = "Git Status" },
  { "<space>nb", "<cmd>Neotree buffers<cr>", desc = "Buffers" },
})

wk.add({
  { "<space>o", group = "Oil" },
  { "<space>oo", "<cmd>Oil<cr>", desc = "Open Oil" },
})

wk.add({
  { "<space>c", group = "Code" },
  { "<space>ca", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<space>cc", "gcc", desc = "Toggle Comment", remap = true },
  { "<space>cf", vim.lsp.buf.format, desc = "Format" },
  { "<space>cr", vim.lsp.buf.rename, desc = "Rename" },
})

wk.add({
  { "<space>m", group = "Markdown" },
  { "<space>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render" },
})

wk.add({
  { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
  { "gr", vim.lsp.buf.references, desc = "References" },
  { "gi", vim.lsp.buf.implementation, desc = "Implementation" },
  { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
  { "gc", group = "Comment" },
  { "gcc", desc = "Toggle Line" },
  { "gco", desc = "Add Below" },
  { "gcO", desc = "Add Above" },
  { "gcA", desc = "Add End of Line" },
})
