local function escape_spaces(path)
  return string.gsub(path, " ", "\\ ")
end

local mp_path = escape_spaces('./🌞 Morning Pages/')
local journal_path = escape_spaces('./📝 Journal/')
local templates_path = escape_spaces('./Templates/')
local todo_path = escape_spaces('./ToDo/')
local routine_path = escape_spaces('./ToDo/Daily Routine.md')

local function get_date()
  local handle = io.popen("date +%Y-%m-%d")
  local result = handle:read("*a")
  handle:close()
  return string.gsub(result, "\n", "")
end

local function replace_date_in_file(file_path)
  local today = get_date()
  local command = "sed -i \"s/{{date}}/" .. today .. "/g\" " .. file_path
  os.execute(command)
end

function BrainWorkspace()
  local today = get_date()
  vim.cmd('edit  ' .. todo_path .. 'Inbox.md')
  vim.cmd('vsplit ' .. todo_path .. today .. '.md')
  vim.cmd('split ' .. routine_path)
end

vim.cmd('command! BrainWorkspace lua BrainWorkspace()')

function CreateJournalFromTemplate()
  local today = get_date()
  local journal_today = journal_path .. 'J-' .. today .. '.md'
  local journal_template = templates_path .. 'TPL-Journal.md'
  os.execute("cp " .. journal_template .. " " .. journal_today)
  replace_date_in_file(journal_today)
  vim.cmd('edit ' .. journal_today)
end

vim.cmd('command! CreateJournalFromTemplate lua CreateJournalFromTemplate()')

function OpenJournal()
  local today = get_date()
  vim.cmd('edit ' .. journal_path .. 'J-' .. today .. '.md')
end

vim.cmd('command! OpenJournal lua OpenJournal()')

function CreateMPFromTemplate()
  local today = get_date()
  local mp_today = mp_path .. 'MP-' .. today .. '.md'
  local mp_template = templates_path .. 'TPL-MorningPage.md'
  os.execute("cp " .. mp_template .. " " .. mp_today)
  replace_date_in_file(mp_today)
  vim.cmd('edit ' .. mp_today)
end

vim.cmd('command! CreateMPFromTemplate lua CreateMPFromTemplate()')

function OpenMP()
  local today = get_date()
  vim.cmd('edit ' .. mp_path .. 'MP-' .. today .. '.md')
end

vim.cmd('command! OpenMP lua OpenMP()')

function OpenDN()
  local today = get_date()
  vim.cmd('edit ' .. todo_path .. today .. '.md')
end

require("which-key").register({
  { "<space>b",  group = "Brain Tools" },
  { "<space>bJ", CreateJournalFromTemplate, desc = "Create Journal from template" },
  { "<space>bM", CreateMPFromTemplate,      desc = "Create Morning Page from template" },
  { "<space>bd", OpenDN,                    desc = "Open Daily Note for today" },
  { "<space>bj", OpenJournal,               desc = "Open Journal for today", },
  { "<space>bm", OpenMP,                    desc = "Open Morning Page for today", },
  { "<space>bw", BrainWorkspace,            desc = "Open workspace", },
}, { prefix = "<space>" })
