{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    calendula = {
      url = "github:pimalaya/calendula?ref=v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rex = {
      url = "https://pkgs.superlogical.com/rex/nix/snapshot.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi = {
      url = "github:earendil-works/pi?ref=v1.4.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-tool-check = {
      url = "github:jruz/agent-tool-check?ref=v0.4.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    github-settings = {
      url = "github:jruz/github-settings?ref=v0.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    woodpecker-settings = {
      url = "git+https://codeberg.org/jruz/woodpecker-settings?ref=refs/tags/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codeberg-settings = {
      url = "git+https://codeberg.org/jruz/codeberg-settings?ref=refs/tags/v0.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-statusline = {
      url = "github:jruz/claude-statusline?ref=v0.5.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    woodpecker-channel = {
      url = "github:jruz/woodpecker-channel?ref=v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    template-sync = {
      url = "github:jruz/template-sync?ref=v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ager = {
      url = "git+https://codeberg.org/jruz/ager?ref=refs/tags/v0.1.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-add-lines = {
      url = "git+https://codeberg.org/jruz/git-add-lines?ref=refs/tags/v0.4.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tree-sitter = {
      url = "github:tree-sitter/tree-sitter?ref=v0.27.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      calendula,
      rex,
      pi,
      agent-tool-check,
      github-settings,
      woodpecker-settings,
      codeberg-settings,
      claude-statusline,
      woodpecker-channel,
      template-sync,
      ager,
      git-add-lines,
      tree-sitter,
      ...
    }:
    let
      mkHome =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          unstable = nixpkgs-unstable.legacyPackages.${system};
          unfree = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "claude";
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            claude = unfree.callPackage ./packages/claude.nix { };
            codex = pkgs.callPackage ./packages/codex.nix { };
            herdr-core = pkgs.callPackage ./packages/herdr-core.nix { };
            inherit
              unstable
              calendula
              rex
              pi
              agent-tool-check
              github-settings
              woodpecker-settings
              codeberg-settings
              claude-statusline
              woodpecker-channel
              template-sync
              ager
              git-add-lines
              tree-sitter
              system
              ;
          };
          modules = [ ./home.nix ];
        };
    in
    {
      homeConfigurations = {
        "jruz@x86_64-linux" = mkHome "x86_64-linux";
        "jruz@aarch64-linux" = mkHome "aarch64-linux";
        "jruz@aarch64-darwin" = mkHome "aarch64-darwin";
      };
    };
}
