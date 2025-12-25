_original_mise_hook=$functions[_mise_hook]

_mise_hook() {
  eval "$_original_mise_hook"
  export PATH="$HOME/.nix-profile/bin:$PATH"
}

export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="$HOME/.orbstack/bin:$PATH"
