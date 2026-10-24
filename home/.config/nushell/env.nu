source _path.nu
source _env-load.nu
source _env-vars.nu

if (which fzf | length) > 0 {
  use _fzf.nu
}


source _direnv.nu

if (which starship | length) > 0 {
  source _starship.nu
}

let zoxide_cache = $"($env.HOME)/.cache/zoxide-init.nu"
if (which zoxide | length) > 0 {
  ^zoxide init nushell | save -f $zoxide_cache
} else {
  "" | save -f $zoxide_cache
}
