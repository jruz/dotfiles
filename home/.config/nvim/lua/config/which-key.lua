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
  { "<space>gb", "<cmd>Git blame<cr>", desc = "Blame" },
  { "<space>gd", "<cmd>Git diff<cr>", desc = "Diff" },
  { "<space>gl", "<cmd>Git log<cr>", desc = "Log" },
})

wk.add({
  { "<space>t", group = "Trouble" },
  { "<space>tt", "<cmd>TroubleToggle<cr>", desc = "Toggle" },
  { "<space>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
  { "<space>td", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
  { "<space>tq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
  { "<space>tl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
  { "<space>tr", "<cmd>TroubleToggle lsp_references<cr>", desc = "References" },
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
  { "<space>nt", "<cmd>NERDTreeToggle<cr>", desc = "Toggle" },
  { "<space>nf", "<cmd>NERDTreeFind<cr>", desc = "Find Current File" },
})

wk.add({
  { "<space>o", group = "Oil" },
  { "<space>oo", "<cmd>Oil<cr>", desc = "Open Oil" },
})

wk.add({
  { "<space>c", group = "Code" },
  { "<space>ca", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<space>cf", vim.lsp.buf.format, desc = "Format" },
  { "<space>cr", vim.lsp.buf.rename, desc = "Rename" },
})

wk.add({
  { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
  { "gr", vim.lsp.buf.references, desc = "References" },
  { "gi", vim.lsp.buf.implementation, desc = "Implementation" },
  { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
})
