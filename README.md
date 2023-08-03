# dotfiles

Welcome to my dotfiles, here's where I try to find a sane way to sync apps and config between my computers

- mac
- windows + wsl2
- linux

## Apps:

- CLI  - Nix + Home Manager [home.nix](/home/.config/home-manager/home.nix)
- GUI - Homebrew [Brewfile](/home-mac/Brewfile)
- Languages - RTX [.tool-version](/home/.tool-versions)
- .config -  with Stow [config](/Makefile)

## CLI Editors:

- NeoVim [init.lua](/home/.config/nvim)
- Vim [.vimrc](/home/.vimrc)
- Emacs [doom](/.config/doom)
- Helix [config.toml](/home/.config/helix/config.toml)

## Terminal stuff:

- Alacritty [alacritty.yml](/home-mac/.config/alacritty/alacritty.yml)
- Tmux [.tmux.cof](/home/.tmux.conf)
- Zellij [config.kdl](/home/.config/zellij/config.kdl)
- ZSH [.zshrc](/home/.zshrc)
- Nushell [.config](/home/.config/nushell)

---

This steps are for myself when I setup a new machine:

### Github

Generate new key

    ssh-keygen -t ed25519 -C "--EMAIL--"
    pbcopy < ~/.ssh/id_ed25519.pub

Add key to https://github.com/settings/keys

Install GPG Key

    gpg --import backup.key

Check git config

    just git

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

    make stow-linux
    make stow-mac


### Home Manager

- https://nixos.org/download.html
- https://nix-community.github.io/home-manager/index.html#sec-install-standalone

```
home-manager switch
```

### Neovim

Open `nvim` first time and let Lazy.vim install all deps.  
Reopen and setup Copilot

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
