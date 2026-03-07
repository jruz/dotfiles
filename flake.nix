{
  description = "Dotfiles linting environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nu-lint = {
      url = "git+https://codeberg.org/wvhulle/nu-lint?ref=refs/tags/v0.0.129";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nu-lint, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nu-lint-pkg = nu-lint.packages.${system}.default;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.biome
              pkgs.fd
              pkgs.nixfmt
              pkgs.selene
              pkgs.shellcheck
              pkgs.taplo
              pkgs.yamllint
              nu-lint-pkg
            ];
          };
        });
    };
}
