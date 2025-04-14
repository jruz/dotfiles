stow:
  make stow

zgen-install:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

git:
  git --no-pager config --global -l

tmux-plugins:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # do Ctrl+a I to install the plugins

mac-outdated:
  brew outdated
  mas outdated

mac-update:
  brew update
  brew upgrade
  mas upgrade

nix-list:
  nix-channel --list

nix-update VERSION:
  nix-channel --list
  nix-channel --add https://nixos.org/channels/nixos-{{VERSION}} nixpkgs
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-{{VERSION}}.tar.gz home-manager
  nix-channel --update
  nix-channel --list

nix-darwin-edit:
	cp -r ~/.config/nix-darwin ~/dev/dotfiles/mac
	nvim ~/dev/dotfiles/mac/nix-darwin/flake.nix

nix-darwin-switch:
	cp -r ~/dev/dotfiles/mac/nix-darwin ~/.config
	nix run nix-darwin -- switch --flake ~/.config/nix-darwin

nix-darwin-update:
	nix flake update --flake ~/.config/nix-darwin
	nix run nix-darwin -- switch --flake ~/.config/nix-darwin
