{ config
, pkgs
, unstable
, claude-code
, codex-cli
, woodpecker-settings
, codeberg-settings
, claude-hooks
, claude-statusline
, system
, ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";
  deff = import ./packages/deff.nix { inherit unstable; };

in
{
  home.username = "jruz";

  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    [
      watch
      curl
      fd
      fontconfig
      fzf
      age
      aria2
      util-linux
      ffmpeg
      gawk
      gnupg
      gnused
      tree
      jq
      yq-go
      lsd
      procs
      zenith
      ripgrep
      sd
      bottom
      rlwrap
      stow
      unzip
      wget
      xclip
      zip
      yazi
      signal-cli
      mermaid-cli
      lsof
      sshpass

      # GIT ------------------------
      deff
      delta
      gh
      git
      git-filter-repo
      gitui
      lazygit
      tea

      # SHELLS ---------------------
      nushell
      zsh
      zinit
      tmux
      tmuxinator
      starship
      zoxide
      direnv

      # EDITORS --------------------
      helix
      # emacs-nox

      # BUILD ----------------------
      openssl

      # VIM ------------------------
      vim
      tree-sitter
      shellcheck
      stylua
      selene
      luajitPackages.jsregexp

      # LSP SERVERS ----------------
      lua-language-server
      bash-language-server
      typescript-language-server
      vscode-langservers-extracted # eslint, jsonls, html, css
      efm-langserver
      bun
      terraform-ls
      tflint
      tfsec
      pylyzer
      biome
      prettier
      shfmt

      # Nix -------------------------
      nixd
      nixfmt

      # AI -------------------------
      claude-code.packages.${system}.default
      codex-cli.packages.${system}.default
      woodpecker-settings.packages.${system}.default
      codeberg-settings.packages.${system}.default
      claude-hooks.packages.${system}.default
      claude-statusline.packages.${system}.default

      # CLOJURE --------------------
      babashka
      clojure-lsp
      clj-kondo
      joker
    ]
    ++ (with unstable; [
      atuin
      bat
      just
      neovim
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.lekton
      usage
      vhs
      woodpecker-cli
      zellij
    ])
    ++ (pkgs.lib.optionals isDarwin [
      darwin.trash
    ])
    ++ (pkgs.lib.optionals (!isDarwin) [
      chromium
      ghostty.terminfo
      podman
      trash-cli
    ])
    ++ (pkgs.lib.optionals (system == "x86_64-linux") [
      masterpdfeditor4
    ]);

  home.file = pkgs.lib.optionalAttrs isDarwin {
    "Library/Application Support/nushell".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.config/nushell";
  };


}
