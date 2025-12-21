{ config, pkgs, unstable, zjstatus, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";
  zjstatusPackage = zjstatus.packages.${system}.default;
  mcp-language-server = pkgs.callPackage ./packages/mcp-language-server.nix { };

in
{
  home.username = "jruz";

  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
      }
    '';
  };

  home.packages = with pkgs;
    [
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
      delta
      gh
      git
      git-crypt
      git-filter-repo
      gitui
      lazygit

      # SHELLS ---------------------
      zsh
      zinit
      nushell
      tmux
      tmuxinator
      starship
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
      vim
      tree-sitter
      shellcheck
      stylua
      selene
      luajitPackages.jsregexp

      # Nix -------------------------
      nixd
      nixfmt-classic

      # RUST -----------------------
      cargo-watch
      cargo-nextest
      bacon
      # cargo-generate
      # cargo-lambda

      # CLOJURE --------------------
      babashka

      # MCP SERVERS ----------------
      mcp-language-server
    ]
    ++ (with unstable; [
      atuin
      mise
      neovim
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.lekton
      rust-analyzer
      usage
      vhs
      zellij
    ])
    ++ (pkgs.lib.optionals (!isDarwin) [
      masterpdfeditor4
    ]);

  home.file.".config/zellij/plugins/zjstatus.wasm".source = "${zjstatusPackage}/bin/zjstatus.wasm";

}
