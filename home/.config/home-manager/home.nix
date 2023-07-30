{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in

{
  home.username = "jruz";

  home.homeDirectory = if pkgs.system == "x86_64-darwin" then "/Users/jruz" else "/home/jruz";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Lekton" ]; })
    asdf-vm
    awscli2
    bat
    curl
    emacs-nox
    fd
    fontconfig
    cargo-watch
    cargo-nextest
    rustup
    frawk
    fzf
    gawk
    git
    gnupg
    helix
    jq
    just
    lsd
    luajitPackages.jsregexp
    neovim
    nixfmt
    nushell
    procs
    ripgrep
    rlwrap
    shellcheck
    stow
    stylua
    tmux
    tmuxinator
    tree-sitter
    unzip
    vim
    wget
    xclip
    zellij
    zip
    zplug
    zsh
  ] ++ (with unstable; [
  ]);
}
