local lualine = require("lualine")

local function word_count()
  local count = vim.fn.wordcount().words
  return string.format('%d words', count)
end

local function filename_with_parent()
  local filepath = vim.fn.expand('%:p')
  if filepath == '' then
    return '[No Name]'
  end
  local filename = vim.fn.expand('%:t')
  local parent = vim.fn.fnamemodify(filepath, ':h:t')
  if parent == '' or parent == '.' then
    return filename
  end
  return parent .. '/' .. filename
end

local markdown_sections = {
  lualine_a = { 'mode' },
  lualine_b = {},
  lualine_c = { filename_with_parent },
  lualine_x = {},
  lualine_y = {},
  lualine_z = { word_count }
}


local markdown = { sections = markdown_sections, filetypes = { 'markdown' } }

lualine.setup({
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { filename_with_parent },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  extensions = { "trouble", markdown }
})
