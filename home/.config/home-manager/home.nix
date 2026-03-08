{ config
, pkgs
, unstable
, system
, ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";
  deff = import ./packages/deff.nix { inherit unstable; };
  mcp-language-server = pkgs.callPackage ./packages/mcp-language-server.nix { };
  zellijinator = pkgs.callPackage ./packages/zellijinator.nix { };

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
      zellijinator
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
      deno
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
      claude-code

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
