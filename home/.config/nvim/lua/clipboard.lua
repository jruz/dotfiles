local function osc52_copy(selection)
  return function(lines)
    local text = table.concat(lines, "\n")
    local b64 = vim.base64.encode(text)
    local osc52 = string.format("\027]52;%s;%s\007", selection, b64)
    io.stdout:write(osc52)
    io.stdout:flush()
  end
end

local function osc52_paste(register)
  return function()
    return vim.fn.getreg(register)
  end
end

vim.g.clipboard = {
  name = 'OSC52',
  copy = {
    ['+'] = osc52_copy('c'),
    ['*'] = osc52_copy('p'),
  },
  paste = {
    ['+'] = osc52_paste('+'),
    ['*'] = osc52_paste('*'),
  },
}
