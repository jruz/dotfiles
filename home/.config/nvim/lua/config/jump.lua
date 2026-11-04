local M = {}

local function is_function(node)
  local type = node:type()
  return type:find("function") ~= nil or type:find("method") ~= nil
end

local function collect_starts(node, starts)
  if is_function(node) then
    local row, col = node:start()
    table.insert(starts, { row, col })
  end
  for child in node:iter_children() do
    collect_starts(child, starts)
  end
  return starts
end

local function is_after(position, cursor)
  return position[1] > cursor[1]
end

local function is_before(position, cursor)
  return position[1] < cursor[1]
end

local function precedes(a, b)
  return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
end

local function jump_function(forward)
  local root = vim.treesitter.get_parser():parse()[1]:root()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local cursor = { row - 1, col }
  local starts = collect_starts(root, {})
  table.sort(starts, precedes)
  local candidates = vim.tbl_filter(function(position)
    if forward then
      return is_after(position, cursor)
    end
    return is_before(position, cursor)
  end, starts)
  local target = forward and candidates[1] or candidates[#candidates]
  vim.api.nvim_win_set_cursor(0, { target[1] + 1, target[2] })
end

function M.next_function()
  jump_function(true)
end

function M.prev_function()
  jump_function(false)
end

return M
