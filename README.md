# dotfiles

Welcome to my dotfiles, here's where I try to find a sane way to sync apps and config between my computers

- mac
- windows + wsl2
- linux

## Apps:

- CLI  - Nix + Home Manager [home.nix](/home/.config/home-manager/home.nix)
- GUI - Homebrew [Brewfile](/home-mac/Brewfile)
- Languages - mise [config.toml](/home/.config/mise/config.toml)
- .config - with Stow [justfile](/justfile)

## CLI Editors:

- NeoVim [init.lua](/home/.config/nvim)
- Vim [.vimrc](/home/.vimrc)
- Emacs [doom](/.config/doom)
- Helix [config.toml](/home/.config/helix/config.toml)

## Terminal stuff:

- Alacritty [alacritty.toml](/home/.config/alacritty/alacritty.toml)
- Ghostty [config](/home/.config/ghostty/config)
- Tmux [.tmux.conf](/home/.tmux.conf)
- Zellij [config.kdl](/home/.config/zellij/config.kdl)
- ZSH [.zshrc](/home/.zshrc)
- Nushell [.config](/home/.config/nushell)

---

## New Machine Setup

### 1. Nix

Install Nix: https://nixos.org/download.html

### 2. Clone repo

    mkdir -p ~/dev
    cd ~/dev
    git clone https://github.com/jruz/dotfiles.git

### 3. Setup

    nix-shell -p just gh stow
    just ssh-keygen your@email.com
    git remote set-url origin git@github.com:jruz/dotfiles.git
    just bootstrap

Bootstrap will detect OS, stow dotfiles, install home-manager packages, configure ssh-agent, and install language runtimes.

### 4. GPG Key

    just gpg-import ~/path/to/key.file

### 5. Git config

    just git-config

### 6. Neovim

Open `nvim` and let Lazy.vim and TreeSitter install deps.

---

## Platform-specific

### Linux

    sudo apt-get install -y zsh
    chsh -s $(which zsh)

### macOS

- Disable auto correct
- Increase speed of keyboard repetition

#### Wacom setup

Settings > Privacy & Security > Accessibility

- Add `/Library/PrivilegedHelperTools/com.wacom.IOManager.app`
  https://support.wacom.com/hc/en-us/articles/9753655984663

### Windows

- Install [AutoHotkey](https://www.autohotkey.com) and remap Ctrl+Tab with script in `dev\dotfiles\windows\AutoHotkey`
