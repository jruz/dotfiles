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
        inherit (builtins.fromJSON (builtins.readFile ./package.json)) engines;
        nodeImage = "registry.jruz.io/node:${engines.node}-${engines.pnpm}";
        bunImage = "registry.jruz.io/bun:${engines.bun}";
        sandbox = pkgs.writeShellScriptBin "sandbox" ''
          set -eu
          project_root="$(${pkgs.git}/bin/git rev-parse --show-toplevel)"
          relative_dir="$(${pkgs.coreutils}/bin/realpath --relative-to="$project_root" "$PWD")"
          runtime_args=()
          case "''${1-}" in
            node|pnpm)
              image=${pkgs.lib.escapeShellArg nodeImage}
              pnpm_store="$HOME/.local/share/pnpm"
              pnpm_cache="$HOME/.cache/pnpm"
              ${pkgs.coreutils}/bin/mkdir --parents "$pnpm_store" "$pnpm_cache"
              runtime_args+=(
                --mount "type=bind,src=$pnpm_store,dst=$pnpm_store"
                --mount "type=bind,src=$pnpm_cache,dst=$pnpm_cache"
                --env "pnpm_config_store_dir=$pnpm_store/store"
                --env "pnpm_config_cache_dir=$pnpm_cache"
              )
              ;;
            bun)
              image=${pkgs.lib.escapeShellArg bunImage}
              ;;
            *)
              printf 'Unsupported sandbox command: %s\n' "''${1-}" >&2
              exit 1
              ;;
          esac
          exec ${pkgs.docker-client}/bin/docker run \
            --interactive \
            --rm \
            --user "$(${pkgs.coreutils}/bin/id --user):$(${pkgs.coreutils}/bin/id --group)" \
            --read-only \
            --cap-drop ALL \
            --security-opt no-new-privileges \
            --tmpfs /tmp \
            --env HOME=/tmp \
            --mount "type=bind,src=$project_root,dst=/app" \
            --workdir "/app/$relative_dir" \
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
            echo "  node         ${engines.node} (docker sandbox)"
            echo "  pnpm         ${engines.pnpm} (docker sandbox)"
            echo "  bun          ${engines.bun} (docker sandbox)"
            echo ""
          '';
        };
      }
    );
}
