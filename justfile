ssh-setup:
  #!/usr/bin/env sh
  if [ "$(uname)" = "Darwin" ]; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  else
    ssh-add ~/.ssh/id_ed25519
  fi

tmux:
  tmuxinator local

stow:
  make stow

zgen-install:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

git-config:
  git --no-pager config --global -l

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

nix-upgrade VERSION:
  nix-channel --list
  nix-channel --add https://nixos.org/channels/nixos-{{VERSION}} nixpkgs
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-{{VERSION}}.tar.gz home-manager
  nix-channel --update
  nix-channel --list

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
