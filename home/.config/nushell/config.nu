$env.config = ($env.config? | default {} | merge {
  show_banner: false
})

source _alias.nu
source _functions.nu
source _gemini.nu
source _keybindings.nu

if (which atuin | length) > 0 {
  source _atuin.nu
}

if (which just | length) > 0 {
  use _just-completions.nu *
}

source ~/.cache/zoxide-init.nu
