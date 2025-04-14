stow: stow-home

stow-home:
	rm -rf ~/.config/home-manager
	stow -t ~ -v home	

stow-mac: stow-home
	stow -t ~ -v home-mac

stow-linux: stow-home
	stow -t ~ -v home-linux

setup-nix:
	nix-channel --add https://nixos.org/channels/nixos-23.11 nixpkgs
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
	nix-channel --list
	nix-channel --update

setup-home-manager:
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
	nix-channel --list
	nix-channel --update
	nix-shell '<home-manager>' -A install
