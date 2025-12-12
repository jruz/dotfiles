{ config, pkgs, zjstatus, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";
  zjstatusPackage = zjstatus.packages.${system}.default;

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
      fzf
      aria2
      util-linux
      ffmpeg
      gawk
      gnupg
      gnused
      tree
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
      git-filter-repo
      delta
      lazygit
      gh

      # SHELLS ---------------------
      zsh
      zinit
      nushell
      zellij
      tmux
      tmuxinator
      starship
      atuin
      zoxide

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
      selene
      luajitPackages.jsregexp

      # Nix -------------------------
      nixd
      nixfmt

      # RUST -----------------------
      cargo-watch
      cargo-nextest
      bacon
      # cargo-generate
      # cargo-lambda

      # CLOJURE --------------------
      babashka

      # Ubuntu ---------------------

      # Unstable --------------------
      mise
      usage
      rust-analyzer
      vhs

    ];

  home.file.".config/zellij/plugins/zjstatus.wasm".source = "${zjstatusPackage}/bin/zjstatus.wasm";

}
