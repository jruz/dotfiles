if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="$HOME/.orbstack/bin:$PATH"
export PATH="$HOME/.amp/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
