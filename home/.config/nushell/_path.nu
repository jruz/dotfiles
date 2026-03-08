let base_paths = [
  "/opt/homebrew/bin"
  $"($env.HOME)/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  "/run/current-system/sw/bin"
  "/usr/local/bin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  $"($env.HOME)/.local/bin"
]

let existing_path = if ($env.PATH? | is-empty) {
  []
} else if ($env.PATH | describe) =~ 'string' {
  $env.PATH | split row (char esep)
} else {
  $env.PATH
}

$env.PATH = (
  $existing_path
  | append $base_paths
  | prepend $"($env.HOME)/.orbstack/bin"
  | prepend $"($env.HOME)/.amp/bin"
  | prepend $"($env.HOME)/.cargo/bin"
  | uniq
)
