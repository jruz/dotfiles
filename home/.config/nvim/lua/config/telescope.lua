local telescope = require("telescope.builtin")
local tabs = require("telescope-tabs")

local next_output = "**/.next/**"
local file_ignores = {
  ".git/*",
  "home/.claude/debug/*",
  "home/.claude/file-history/*",
  "home/.claude/history.jsonl",
  "home/.claude/plans/*",
  "home/.claude/plugins/*",
  "home/.claude/projects/*",
  "home/.claude/session-env/*",
  "home/.claude/shell-snapshots/*",
  "home/.claude/stats-cache.json",
  "home/.claude/statsig/*",
  "home/.claude/telemetry/*",
  "home/.claude/todos/*",
  "node_modules/*",
  "tmp/*",
  "build/*",
  ".sqlx/*",
  next_output,
  "*/node_modules/*",
  "*/.terraform/*",
  "*/build/*",
  "*/*.tfstate.*",
  "*/*.DS_Store",
  "target/*",
  ".clj-kondo",
  ".cpcache",
  ".lsp",
}

local find_command = vim.list_extend({ "rg", "--files", "--hidden", "--no-ignore-vcs", "--no-ignore-dot" },
  vim.tbl_map(function(glob)
    return "--glob=!" .. glob
  end, file_ignores))

vim.keymap.set("n", "<C-P>", function()
  telescope.find_files({ find_command = find_command })
end, { silent = true })
vim.keymap.set("n", "<C-B>", telescope.buffers, {})
vim.keymap.set("n", "<C-F>", function()
  telescope.live_grep({ glob_pattern = "!" .. next_output })
end, {})
vim.keymap.set("n", "<leader>ft", tabs.list_tabs, { desc = "Find tabs" })
