$env.config = ($env.config? | default {} | merge {
  show_banner: false
  history: {
    file_format: sqlite
    isolation: true
  }
})

$env.config.rm.always_trash = true

source _alias.nu
use _functions.nu *
source _keybindings.nu
use _just-completions.nu *

if "__zoxide_hooked" in $env and ($env.__zoxide_hooked | describe) == "string" {
  hide-env __zoxide_hooked
}

source ~/.cache/zoxide-init.nu
