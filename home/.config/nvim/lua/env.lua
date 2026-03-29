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
