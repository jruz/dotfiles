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
    rtx
    awscli2
    bat
    curl
    fd
    fontconfig
    frawk
    fzf
    gawk
    gnupg
    gnused
    jq
    just
    lsd
    procs
    ripgrep
    rlwrap
    stow
    unzip
    wget
    xclip
    zip
    # GIT ------------------------
    git
    git-crypt
    # SHELLS ---------------------
    nushell
    zplug
    zsh
    zellij
    tmux
    tmuxinator
    # EDITORS --------------------
    helix
    emacs-nox
    # BUILD ----------------------
    #llvm
    #clang
    #mold
    #cmake
    #pkg-config
    # VIM ------------------------
    neovim
    vim
    tree-sitter
    shellcheck
    stylua
    luajitPackages.jsregexp
    nixfmt
    # RUST -----------------------
    cargo-watch
    cargo-nextest
    cargo-leptos
    cargo-generate
    trunk
    rustup
    dart-sass
    # CLOJURE --------------------
    babashka
  ] ++ (with unstable; [
  ]);
}
