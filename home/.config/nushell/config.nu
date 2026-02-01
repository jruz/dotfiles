$env.config = ($env.config? | default {} | merge {
  show_banner: false
})

source _alias.nu
source _functions.nu
source _keybindings.nu
source _just-completions.nu

if "__zoxide_hooked" in $env and ($env.__zoxide_hooked | describe) == "string" {
  hide-env __zoxide_hooked
}

source ~/.cache/zoxide-init.nu
