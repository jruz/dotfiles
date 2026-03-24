{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.74";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-cli = {
      url = "github:sadjow/codex-cli-nix?ref=v0.116.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    woodpecker-settings = {
      url = "git+https://codeberg.org/jruz/woodpecker-settings?ref=refs/tags/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      claude-code,
      codex-cli,
      woodpecker-settings,
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
            inherit
              unstable
              claude-code
              codex-cli
              woodpecker-settings
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
