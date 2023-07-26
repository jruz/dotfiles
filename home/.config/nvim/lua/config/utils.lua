local exports = {}

function exports.map(func, arr)
  local new_arr = {}
  for i, v in ipairs(arr) do
    new_arr[i] = func(v)
  end
  return new_arr
end

function exports.filter(func, arr)
  local new_arr = {}
  for _, v in ipairs(arr) do
    if func(v) then
      new_arr[#new_arr + 1] = v
    end
  end
  return new_arr
end

function exports.forEach(func, arr)
  for _, v in ipairs(arr) do
    func(v)
  end
end

function exports.concat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

return exports
