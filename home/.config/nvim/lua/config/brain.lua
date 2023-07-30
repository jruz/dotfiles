function EscapeSpaces(path)
  return string.gsub(path, " ", "\\ ")
end

local mp_path = EscapeSpaces('./🌞 Morning Pages/')
local journal_path = EscapeSpaces('./📝 Journal/')
local templates_path = EscapeSpaces('./Templates/')
local todo_path = EscapeSpaces('./ToDo/')

function GetDate()
  local handle = io.popen("date +%Y-%m-%d")
  local result = handle:read("*a")
  handle:close()
  return string.gsub(result, "\n", "")
end

function BrainWorkspace()
  local today = GetDate()
  vim.cmd('edit  ' .. todo_path .. 'Inbox.md')
  vim.cmd('vsplit ' .. todo_path .. today .. '.md')
  vim.cmd('split ' .. mp_path .. 'MP-' .. today .. '.md')
end

vim.cmd('command! BrainWorkspace lua BrainWorkspace()')

function CreateJournalFromTemplate()
  local today = GetDate()
  local journal_today = journal_path .. 'J-' .. today .. '.md'
  local journal_template = templates_path .. 'TPL-Journal.md'
  os.execute("cp " .. journal_template .. " " .. journal_today)
end

vim.cmd('command! CreateJournalFromTemplate lua CreateJournalFromTemplate()')

function OpenJournal()
  local today = GetDate()
  vim.cmd('edit ' .. journal_path .. 'J-' .. today .. '.md')
end

vim.cmd('command! OpenJournal lua OpenJournal()')

function CreateMPFromTemplate()
  local today = GetDate()
  local mp_today = mp_path .. 'MP-' .. today .. '.md'
  local mp_template = templates_path .. 'TPL-MorningPage.md'
  os.execute("cp " .. mp_template .. " " .. mp_today)
end

vim.cmd('command! CreateMPFromTemplate lua CreateMPFromTemplate()')

function OpenMP()
  local today = GetDate()
  vim.cmd('edit ' .. mp_path .. 'MP-' .. today .. '.md')
end

vim.cmd('command! OpenMP lua OpenMP()')

require("which-key").register({
  b = {
    name = "Brain Tools",
    w = { BrainWorkspace, "Open workspace" },
    k = { CreateJournalFromTemplate, "Create Journal from template" },
    j = { OpenJournal, "Open Journal for today" },
    n = { CreateMPFromTemplate, "Create Morning Page from template" },
    M = { OpenMP, "Open Morning Page for today" },
  },
}, { prefix = "<space>" })
