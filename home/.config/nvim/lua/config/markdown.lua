local function hasExtension(extension)
  return vim.fn.expand('%:e') == extension
end


function MyHandleEnter()
  local line = vim.api.nvim_get_current_line()
  if hasExtension('md') then
    if line:match("^- %[") then
      vim.cmd 'normal! o'
      vim.api.nvim_input('- [ ] ')
    elseif line:match("^- ") then
      vim.cmd 'normal! o'
      vim.api.nvim_input('- ')
    else
      vim.cmd 'normal! o'
    end
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
  end
end

function MyHandleO()
  local line = vim.api.nvim_get_current_line()
  if hasExtension('md') then
    if line:match("^- %[") then
      vim.cmd 'normal! o'
      vim.api.nvim_feedkeys('a', 'i', true)
      vim.api.nvim_input('- [ ] ')
    elseif line:match("^- ") then
      vim.cmd 'normal! o'
      vim.api.nvim_feedkeys('a', 'i', true)
      vim.api.nvim_input('- ')
    else
      vim.cmd 'normal! o'
    end
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o', true, true, true), 'n', true)
  end
end

vim.api.nvim_set_keymap('i', '<CR>', '<Cmd>lua MyHandleEnter()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'o', '<Cmd>lua MyHandleO()<CR>', { noremap = true, silent = true })

function ResetTodos()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = {}

  for i, line in ipairs(lines) do
    if line:match("^- %[x") then
      result[i] = line:gsub("%[x%]", "[ ]")
    else
      result[i] = line
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
end

vim.cmd('command! ResetTodos lua ResetTodos()')

function ToggleTodo()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  if line:match("^%s*%- %[[ x]%]") then
    if line:find("%- %[[ ]]") then
      line = line:gsub("%- %[[ ]]", "- [x]")
    else
      line = line:gsub("%- %[[x]]", "- [ ]")
    end
    vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { line })
  end
end

vim.api.nvim_set_keymap('n', '<Space><Space>', ':lua ToggleTodo()<cr>', { noremap = true })