{
  config,
  pkgs,
  unstable,
  zjstatus,
  system,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";
  zjstatusPackage = zjstatus.packages.${system}.default;
  mcp-language-server = pkgs.callPackage ./packages/mcp-language-server.nix { };
  zellijinator = pkgs.callPackage ./packages/zellijinator.nix { };

in
{
  home.username = "jruz";

  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.11";

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
      just
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

      # GIT ------------------------
      delta
      gh
      git
      git-crypt
      git-filter-repo
      gitui
      lazygit
      tea

      # SHELLS ---------------------
      zsh
      zinit
      tmux
      tmuxinator
      zellijinator
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

      # Nushell --------------------

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
      bat
      mise
      neovim
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.lekton
      nushell
      rust-analyzer
      usage
      vhs
      woodpecker-cli
      zellij
    ])
    ++ (pkgs.lib.optionals isDarwin [
      darwin.trash
    ])
    ++ (pkgs.lib.optionals (!isDarwin) [
      masterpdfeditor4
      trash-cli
    ]);

  home.file = pkgs.lib.optionalAttrs isDarwin {
    "Library/Application Support/nushell".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.config/nushell";
  };

  home.activation.copyZjstatus = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    pluginDir="${homeDirectory}/.config/zellij/plugins"
    pluginFile="$pluginDir/zjstatus.wasm"
    mkdir -p "$pluginDir"
    if [ -L "$pluginFile" ] || [ -f "$pluginFile" ]; then
      $DRY_RUN_CMD rm -f "$pluginFile"
    fi
    $DRY_RUN_CMD cp -f ${zjstatusPackage}/bin/zjstatus.wasm "$pluginFile"
  '';

}
