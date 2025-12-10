{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs = { nixpkgs, home-manager, zjstatus, ... }:
    let
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit zjstatus system; };
        modules = [ ./home.nix ];
      };
    in
    {
      homeConfigurations = {
        jruz = mkHome "aarch64-darwin";
        "jruz@x86_64-linux" = mkHome "x86_64-linux";
        "jruz@aarch64-linux" = mkHome "aarch64-linux";
        "jruz@x86_64-darwin" = mkHome "x86_64-darwin";
        "jruz@aarch64-darwin" = mkHome "aarch64-darwin";
      };
    };
}
