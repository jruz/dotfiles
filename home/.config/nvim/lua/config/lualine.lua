local lualine = require("lualine")

local function word_count()
  local count = vim.fn.wordcount().words
  return string.format('%d words', count)
end

local file_extension = vim.fn.expand('%:e')

local function getSections()
  if file_extension == 'txt' or file_extension == "md" then
    return {
      lualine_a = { 'mode' },
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { word_count }
    }
  end

  return {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
end

lualine.setup({ sections = getSections() })
