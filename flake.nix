{
  description = "DevShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        sandbox = pkgs.writeShellScriptBin "sandbox" ''
          exec docker run \
            --rm \
            --read-only \
            --cap-drop ALL \
            --security-opt no-new-privileges \
            --tmpfs /tmp \
            --mount "type=bind,src=$PWD,dst=/app" \
            --mount type=volume,src=dotfiles-bun-modules,dst=/app/node_modules \
            --mount type=volume,src=dotfiles-bun-cache,dst=/root/.bun \
            --workdir /app \
            registry.jruz.io/bun:1.3.13 \
            "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            deadnix
            fd
            just
            nixfmt
            nushell
            ripgrep
            sandbox
            selene
            shellcheck
            statix
            taplo
            yamllint
          ];

          shellHook = ''
            echo ""
            echo "  Nix Shell"
            echo "  ───────────────────────────"
            echo ""
          '';
        };
      }
    );
}
