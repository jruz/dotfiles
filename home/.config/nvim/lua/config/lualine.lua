local lualine = require("lualine")

local function word_count()
  local count = vim.fn.wordcount().words
  return string.format('%d words', count)
end

local markdown_sections = {
  lualine_a = { 'mode' },
  lualine_b = {},
  lualine_c = { 'filename' },
  lualine_x = {},
  lualine_y = {},
  lualine_z = { word_count }
}


local markdown = { sections = markdown_sections, filetypes = { 'markdown' } }

lualine.setup({ extensions = { "trouble", markdown } })
