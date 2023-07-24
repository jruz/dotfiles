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
