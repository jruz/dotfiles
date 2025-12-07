lint: lint-sh

lint-sh:
  shellcheck \
    --shell=bash \
    -e SC1090 `# can't follow non-constant source` \
    -e SC1091 `# can't follow source to external file` \
    **/*.sh

ssh-keygen EMAIL:
  #!/usr/bin/env sh
  ssh-keygen -t ed25519 -C "{{EMAIL}}"
  gh auth login
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)"

ssh-setup:
  #!/usr/bin/env sh
  if [ "$(uname)" = "Darwin" ]; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  else
    ssh-add ~/.ssh/id_ed25519
  fi

tmux:
  tmuxinator local

stow-home:
  rm -rf ~/.config/home-manager
  stow -t ~ -v home

stow-mac: stow-home
  stow -t ~ -v home-mac

stow-linux: stow-home
  stow -t ~ -v home-linux

stow: stow-home

zgen-install:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

git-config:
  git --no-pager config --global -l

gpg-import KEYFILE:
  #!/usr/bin/env sh
  gpg --import "{{KEYFILE}}"
  KEY_ID=$(gpg --with-colons --import-options show-only --import "{{KEYFILE}}" | awk -F: '/^pub:/ {print $5}')
  echo "$KEY_ID:6:" | gpg --import-ownertrust
  echo "Imported and trusted key: $KEY_ID"

tmux-plugins:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # do Ctrl+a I to install the plugins

mise-upgrade:
  mise upgrade --bump

mise-outdated:
  mise outdated --bump

mise-clean:
  mise prune

mac-outdated:
  brew outdated
  mas outdated

mac-update:
  brew update
  cd home-mac && brew bundle upgrade

ubuntu-update:
  sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove

nix-list:
  nix-channel --list

nix-update:
  nix-channel --update
  home-manager switch

nix-latest:
  gh api repos/NixOS/nixpkgs/branches --paginate -q '.[].name' | grep -E '^nixos-[0-9]+\.[0-9]+$' | sort -V | tail -1 | cut -d- -f2

nix-upgrade VERSION:
  nix-channel --list
  nix-channel --add https://nixos.org/channels/nixos-{{VERSION}} nixpkgs
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-{{VERSION}}.tar.gz home-manager
  nix-channel --update
  nix-channel --list

nix-setup VERSION:
  just nix-upgrade {{VERSION}}
  nix-shell '<home-manager>' -A install

bootstrap:
  #!/usr/bin/env sh
  VERSION=$(just nix-latest)
  echo "🚀 Starting bootstrap with NixOS $VERSION"
  echo ""
  echo "📁 Stowing dotfiles..."
  if [ "$(uname)" = "Darwin" ]; then
    just stow-mac
  else
    just stow-linux
  fi
  echo ""
  echo "❄️  Setting up Nix channels and Home Manager..."
  just nix-setup $VERSION
  echo ""
  echo "🔑 Configuring SSH agent..."
  just ssh-setup
  echo ""
  echo "🛠️  Installing language runtimes with mise..."
  mise install
  echo ""
  echo "✅ Bootstrap complete!"

nix-darwin-diff:
	vimdiff ~/.config/nix-darwin/flake.nix ~/dev/dotfiles/mac/nix-darwin/flake.nix

nix-darwin-edit:
	cp -r ~/.config/nix-darwin ~/dev/dotfiles/mac
	nvim ~/dev/dotfiles/mac/nix-darwin/flake.nix

nix-darwin-switch:
	cp -r ~/dev/dotfiles/mac/nix-darwin ~/.config
	sudo darwin-rebuild switch --flake ~/.config/nix-darwin

nix-darwin-update:
	nix flake update --flake ~/.config/nix-darwin
	sudo darwin-rebuild switch --flake ~/.config/nix-darwin

nix-clean:
  nix-collect-garbage

clean: nix-clean mise-clean

ip-router:
  #!/usr/bin/env nu
  let match = arp -a | lines | find '7c:10:c9:b3:b0:d8' | first?
  if $match == null { error make {msg: "Router not found in ARP table"} }
  let ip = $match | parse -r '\((?<ip>[0-9.]+)\)' | get ip.0?
  if $ip == null { error make {msg: "Could not parse IP from ARP entry"} }
  print $"http://($ip)"

ip-repeater:
  #!/usr/bin/env nu
  let match = arp -a | lines | find '8:8a:f1:f:69:f6' | first?
  if $match == null { error make {msg: "Repeater not found in ARP table"} }
  let ip = $match | parse -r '\((?<ip>[0-9.]+)\)' | get ip.0?
  if $ip == null { error make {msg: "Could not parse IP from ARP entry"} }
  print $"http://($ip)"
