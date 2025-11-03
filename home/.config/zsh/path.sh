# Prioritize Nix binaries over mise for global tools
# This ensures tools like rust-analyzer from Nix take precedence
# We need to wrap the mise hook to ensure Nix stays first
_original_mise_hook=$functions[_mise_hook]

_mise_hook() {
  eval "$_original_mise_hook"
  export PATH="$HOME/.nix-profile/bin:$PATH"
}

export PATH="$HOME/.nix-profile/bin:$PATH"
