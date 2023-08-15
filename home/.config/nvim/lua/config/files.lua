local Path = require('plenary.path')

function RenameFile(new_name)
  local old_path = Path:new(vim.fn.expand('%:p'))
  old_path:rename(new_name)
  local new_path = old_path:parent() / new_name

  vim.api.nvim_command('edit ' .. new_path:filename())
end
