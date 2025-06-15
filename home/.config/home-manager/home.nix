{ config, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> { };
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";

in
{
  home.username = "jruz";

  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs;
    [
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.lekton
      bat
      watch
      curl
      fd
      fontconfig
      frawk
      fzf
      aria2
      util-linux
      ffmpeg
      gawk
      gnupg
      gnused
      jq
      just
      lsd
      procs
      zenith
      ripgrep
      bottom
      rlwrap
      stow
      unzip
      wget
      xclip
      zip
      yazi

      # GIT ------------------------
      git
      git-crypt
      lazygit
      gitui

      # SHELLS ---------------------
      zsh
      zinit
      nushell
      zellij
      tmux
      tmuxinator

      # EDITORS --------------------
      helix
      # emacs-nox

      # BUILD ----------------------
      openssl
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

      # Nix -------------------------
      nixd
      nixfmt

      # RUST -----------------------
      cargo-watch
      cargo-nextest
      bacon
      rust-analyzer
      # cargo-generate
      # cargo-lambda

      # CLOJURE --------------------
      babashka
      
      # Ubuntu ---------------------
    ] ++ (with unstable; [ mise ]);
}
