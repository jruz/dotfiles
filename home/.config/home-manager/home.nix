{
  config,
  pkgs,
  unstable,
  nixpkgs-zellij,
  claude-code,
  codex-cli,
  pi,
  woodpecker-settings,
  codeberg-settings,
  claude-hooks,
  claude-statusline,
  ager,
  git-add-lines,
  tree-sitter,
  system,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;
  homeDirectory = if isDarwin then "/Users/jruz" else "/home/jruz";

in
{
  home = {
    username = "jruz";
    inherit homeDirectory;
    stateVersion = "25.05";

    packages =
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
        coreutils
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
        bat
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
        ntfy-sh
        vhs
        lsof
        sshpass

        # LANGUAGES ------------------
        babashka
        bun

        # GIT ------------------------
        delta
        gh
        git
        git-filter-repo
        gitui
        lazygit
        tea

        # SHELLS ---------------------
        atuin
        nixpkgs-zellij.zellij
        nushell
        zsh
        zinit
        unstable.tmux
        unstable.tmuxinator
        starship
        zoxide
        unstable.direnv

        # EDITORS --------------------
        helix
        # emacs-nox

        # BUILD ----------------------
        openssl

        # VIM ------------------------
        vim
        tree-sitter.packages.${system}.cli
        shellcheck
        stylua
        selene
        luajitPackages.jsregexp
        lua-language-server
        bash-language-server
        typescript-language-server
        vscode-langservers-extracted # eslint, jsonls, html, css
        terraform-ls
        tflint
        tfsec
        pylyzer
        prettier
        shfmt

        # Nix -----------------------
        nixd
        nixfmt

        # AI -------------------------
        claude-code.packages.${system}.default
        codex-cli.packages.${system}.default
        gemini-cli
        pi.packages.${system}.default

        # PERSONAL PROJECTS -------
        woodpecker-settings.packages.${system}.default
        codeberg-settings.packages.${system}.default
        claude-hooks.packages.${system}.default
        claude-statusline.packages.${system}.default
        ager.packages.${system}.default
        git-add-lines.packages.${system}.default

        # CLOJURE --------------------
        clojure-lsp
        clj-kondo
        joker
      ]
      ++ (with unstable; [
        just
        neovim
        nerd-fonts.dejavu-sans-mono
        nerd-fonts.lekton
        usage
        woodpecker-cli
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

    file = pkgs.lib.optionalAttrs isDarwin {
      "Library/Application Support/nushell".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.config/nushell";
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
