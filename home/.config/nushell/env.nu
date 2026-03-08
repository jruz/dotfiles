source _path.nu
source _env-load.nu
source _env-vars.nu

if (which fzf | length) > 0 {
  source _fzf.nu
}


if (which direnv | length) > 0 {
  source _direnv.nu
}

if (which starship | length) > 0 {
  source _starship.nu
}

let zoxide_cache = $"($env.HOME)/.cache/zoxide-init.nu"
if (which zoxide | length) > 0 {
  if not ($zoxide_cache | path exists) {
    zoxide init nushell | save -f $zoxide_cache
  }
} else {
  if not ($zoxide_cache | path exists) {
    "" | save -f $zoxide_cache
  }
}
