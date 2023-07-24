stow-home:
	rm ~/.config/home-manager/home.nix
	stow -t ~ -v home	

stow-mac: stow-home
	stow -t ~ -v home-mac

stow-linux: stow-home
	stow -t ~ -v home-linux
