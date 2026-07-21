{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-zellij.url = "github:NixOS/nixpkgs/8777c98512d0f9fd40955686a4c759fa1eb2ebad";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.112";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-cli = {
      url = "github:sadjow/codex-cli-nix?ref=v0.144.3";
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
    claude-hooks = {
      url = "git+https://codeberg.org/jruz/claude-hooks?ref=refs/tags/v0.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-statusline = {
      url = "git+https://codeberg.org/jruz/claude-statusline?ref=refs/tags/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ager = {
      url = "git+https://codeberg.org/jruz/ager?ref=refs/tags/v0.1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tree-sitter = {
      url = "github:tree-sitter/tree-sitter?ref=v0.26.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-zellij,
      home-manager,
      claude-code,
      codex-cli,
      woodpecker-settings,
      codeberg-settings,
      claude-hooks,
      claude-statusline,
      ager,
      tree-sitter,
      ...
    }:
    let
      mkHome =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          unstable = nixpkgs-unstable.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            nixpkgs-zellij = nixpkgs-zellij.legacyPackages.${system};
            inherit
              unstable
              claude-code
              codex-cli
              woodpecker-settings
              codeberg-settings
              claude-hooks
              claude-statusline
              ager
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
        "jruz@x86_64-darwin" = mkHome "x86_64-darwin";
        "jruz@aarch64-darwin" = mkHome "aarch64-darwin";
      };
    };
}
