if vim.fn.executable("cargo") == 0 then
  local paths_to_add = {}

  local cargo_bin = vim.fn.expand("~/.cargo/bin")
  if vim.fn.isdirectory(cargo_bin) == 1 then
    table.insert(paths_to_add, cargo_bin)
  end

  local rust_version = vim.fn.trim(vim.fn.system("mise current rust 2>/dev/null"))
  if rust_version ~= "" and vim.v.shell_error == 0 then
    if not vim.env.RUSTUP_TOOLCHAIN then
      vim.env.RUSTUP_TOOLCHAIN = rust_version
    end
    if not vim.env.RUSTUP_HOME then
      vim.env.RUSTUP_HOME = vim.fn.expand("~/.rustup")
    end

    local mise_rust_install_base = vim.fn.expand("~/.local/share/mise/installs/rust")
    local rust_bin_dirs = vim.fn.glob(mise_rust_install_base .. "/*/bin", false, true)
    if #rust_bin_dirs > 0 then
      for _, bin_dir in ipairs(rust_bin_dirs) do
        if vim.fn.isdirectory(bin_dir) == 1 and vim.fn.resolve(bin_dir) == bin_dir then
          table.insert(paths_to_add, bin_dir)
          break
        end
      end
    end
  end

  local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
  if vim.fn.isdirectory(mise_shims) == 1 then
    table.insert(paths_to_add, mise_shims)
  end

  local mise_bin = vim.fn.expand("~/.local/bin")
  if vim.fn.isdirectory(mise_bin) == 1 then
    table.insert(paths_to_add, mise_bin)
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
