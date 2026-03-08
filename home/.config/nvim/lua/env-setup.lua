if vim.fn.executable("cargo") == 0 then
  local paths_to_add = {}

  local cargo_bin = vim.fn.expand("~/.cargo/bin")
  if vim.fn.isdirectory(cargo_bin) == 1 then
    table.insert(paths_to_add, cargo_bin)
  end

  local local_bin = vim.fn.expand("~/.local/bin")
  if vim.fn.isdirectory(local_bin) == 1 then
    table.insert(paths_to_add, local_bin)
  end

  if #paths_to_add > 0 then
    vim.env.PATH = table.concat(paths_to_add, ":") .. ":" .. vim.env.PATH
  end
end

local function osc52_copy(register)
  return function(lines)
    local text = table.concat(lines, "\n")
    local b64 = vim.base64.encode(text)
    local osc52 = string.format("\027]52;%s;%s\007", register, b64)
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
    ['+'] = osc52_copy('+'),
    ['*'] = osc52_copy('*'),
  },
  paste = {
    ['+'] = osc52_paste('+'),
    ['*'] = osc52_paste('*'),
  },
}
