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
        pkgs = nixpkgs.legacyPackages.${system};
        bunVersion = "1.3.13";
        nodeVersion = "24.21.0";
        bunImage = "registry.jruz.io/bun:${bunVersion}";
        pnpmVersion = "11.27.0";
        nodeImage = "registry.jruz.io/node:${nodeVersion}-${pnpmVersion}";
        sandbox = pkgs.writeShellScriptBin "sandbox" ''
          set -eu
          runtime_args=()
          case "''${1-}" in
            bun|bunx)
              image=${pkgs.lib.escapeShellArg bunImage}
              runtime_args+=(
                --mount "type=bind,src=$HOME/.bun/install/cache,dst=/cache"
                --env BUN_INSTALL_CACHE_DIR=/cache
              )
              ;;
            node|pnpm)
              image=${pkgs.lib.escapeShellArg nodeImage}
              runtime_args+=(
                --mount "type=bind,src=$HOME/.local/share/pnpm,dst=/pnpm-store"
                --mount "type=bind,src=$HOME/.cache/pnpm,dst=/pnpm-cache"
                --env pnpm_config_store_dir=/pnpm-store/store
                --env pnpm_config_cache_dir=/pnpm-cache
              )
              ;;
            *)
              printf 'Unsupported sandbox command: %s\n' "''${1-}" >&2
              exit 1
              ;;
          esac
          exec docker run \
            --rm \
            --user "$(id -u):$(id -g)" \
            --read-only \
            --cap-drop ALL \
            --security-opt no-new-privileges \
            --tmpfs /tmp \
            --mount "type=bind,src=$PWD,dst=/app" \
            --env HOME=/tmp \
            --workdir /app \
            "''${runtime_args[@]}" \
            "$image" \
            "$@"
        '';
        defaultPackages = with pkgs; [
          deadnix
          fd
          just
          nixfmt
          nu-lint
          nushell
          ripgrep
          sandbox
          selene
          shellcheck
          statix
          taplo
          yamllint
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = defaultPackages;

          shellHook = ''
            echo ""
            echo "  pnpm Development Shell"
            echo "  ──────────────────────"
            echo "  nixpkgs      ${pkgs.lib.trivial.release}"
            echo "  node         ${nodeVersion} (sandbox)"
            echo "  pnpm         ${pnpmVersion} (sandbox)"
            echo "  bun          ${bunVersion} (sandbox)"
            echo ""
          '';
        };
      }
    );
}
