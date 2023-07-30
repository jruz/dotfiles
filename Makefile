stow: stow-home

stow-home:
	rm -r ~/.config/home-manager
	stow -t ~ -v home	

stow-mac: stow-home
	stow -t ~ -v home-mac

stow-linux: stow-home
	stow -t ~ -v home-linux
