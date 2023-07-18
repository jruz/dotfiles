{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in

{
  home.username = "jruz";

  # Linux path
  # home.homeDirectory = "/home/jruz";
  # MacOS path
  # home.homeDirectory = "/Users/jruz";

  home.homeDirectory = if pkgs.system == "x86_64-darwin" then "/Users/jruz" else "/home/jruz";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    asdf-vm
    bat
    curl
    fd
    fontconfig
    frawk
    fzf
    gawk
    git
    gnupg
    jq
    just
    lsd
    procs
    ripgrep
    rlwrap
    tmux
    tmuxinator
    unzip
    vim
    wget
    xclip
    zplug
    zsh
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Lekton" ]; })
    stylua
    nixfmt
    zip
    awscli2
    terraform
    tree-sitter
    stow
    neovim
    luajitPackages.jsregexp
    cargo-watch
  ] ++ (with unstable; [
  ]);
}
