local function osc52_register(selection)
  local contents = { { '' }, 'v' }
  local copy = require('vim.ui.clipboard.osc52').copy(selection)

  return {
    copy = function(lines, regtype)
      contents = { vim.deepcopy(lines), regtype }
      copy(lines)
    end,
    paste = function()
      return vim.deepcopy(contents)
    end,
  }
end

local clipboard = osc52_register('+')
local primary = osc52_register('*')

vim.g.clipboard = {
  name = 'OSC52',
  copy = {
    ['+'] = clipboard.copy,
    ['*'] = primary.copy,
  },
  paste = {
    ['+'] = clipboard.paste,
    ['*'] = primary.paste,
  },
}
