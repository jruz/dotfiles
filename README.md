# dotfiles

Welcome to my dotfiles, here's where I try to find a sane way to sync apps and config between my computers

- mac
- windows + wsl2
- linux

## Apps:

- CLI Nix + Home Manager home.nix
- GUI Homebrew brewfile
- Languages ASDF .tool-version
- .config with Stow config

## CLI Editors:

- NeoVim [config](/home/.config/nvim)
- Vim config
- Emacs config
- Helix config

## Terminal stuff:

- Alacritty config
- Tmux config
- Zellij config
- ZSH config
- Nushell config

---

This steps are for myself when I setup a new machine:

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

### Mac settings

- Disable auto correct
- Increase speed of keyboard repetition

#### Wacom setup

Settings > Privacy & Security > Accessibility

- Add `/Library/PrivilegedHelperTools/com.wacom.IOManager.app`  
  https://support.wacom.com/hc/en-us/articles/9753655984663

### Windows

- Install [AutoHotkey](https://www.autohotkey.com) and remap Ctrl+Tab with script in `dev\dotfiles\windows\AutoHotkey`
