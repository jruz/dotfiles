set working-directory := '..'

diff:
    vimdiff ~/.config/nix-darwin/flake.nix ~/dev/dotfiles/mac/nix-darwin/flake.nix

edit:
    cp -r ~/.config/nix-darwin ~/dev/dotfiles/mac
    nvim ~/dev/dotfiles/mac/nix-darwin/flake.nix

switch:
    cp -r ~/dev/dotfiles/mac/nix-darwin ~/.config
    sudo darwin-rebuild switch --flake ~/.config/nix-darwin

update:
    nix flake update --flake ~/dev/dotfiles/mac/nix-darwin
    just nix-darwin::switch
