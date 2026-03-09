{
  description = "DevShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            biome
            bun
            fd
            nixfmt
            selene
            shellcheck
            taplo
            yamllint
          ];

          shellHook = ''
            echo ""
            echo "  Dotfiles Development Shell"
            echo "  ───────────────────────────"
            echo "  Bun:         ${pkgs.bun.version}"
            echo ""
          '';
        };
      });
}
