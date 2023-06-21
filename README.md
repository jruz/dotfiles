# dotfiles

### Github
Generate new key

    ssh-keygen -t ed25519 -C "javi@jruz"
    pbcopy < ~/.ssh/id_ed25519.pub

Add key to https://github.com/settings/keys

Clone repo

    mkdir -p ~/dev/personal
    cd ~/dev
    git clone git@github.com:jruz/dotfiles.git
    

### Homebrew

- https://brew.sh

```
brew bundle
```

### Stow

Install Stow and link dotfiles

    stow -t ~ -v home

### Home Manager

- https://nixos.org/download.html
- https://nix-community.github.io/home-manager/index.html#sec-install-standalone

```
home-manager switch
```

### Neovim

    # auth
    :Copilot
