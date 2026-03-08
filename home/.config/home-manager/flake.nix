{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nu-lint = {
      url = "git+https://codeberg.org/wvhulle/nu-lint";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nu-lint, ... }:
    let
      mkHome = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          unstable = nixpkgs-unstable.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit unstable nu-lint system; };
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
