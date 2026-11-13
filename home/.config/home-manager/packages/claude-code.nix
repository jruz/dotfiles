{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  procps,
  ripgrep,
  bubblewrap,
  socat,
}:

let
  version = "2.1.285";
  targets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "51f09bd1e021d9fa8a1864c179799bd37cb39962a937935c5cf6823398e86db4";
    };
    x86_64-darwin = {
      name = "darwin-x64";
      sha256 = "24835f7ca4b4338c33ad21c98a3402d9c22f89b8055075d18828e97973844ec3";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "24fac77749bed3d91365d6b6915aa4b824e14318ecb6bc17adbc192f01c9173d";
    };
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "33dad1ec615a2e08cc78b494f05c110e49916de2c79d78ec8799ebf46b233d29";
    };
  };
  target = targets.${stdenv.hostPlatform.system};
  runtimePath = lib.makeBinPath (
    [
      procps
      ripgrep
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      bubblewrap
      socat
    ]
  );
in
stdenv.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-code-releases/${version}/${target.name}/claude";
    inherit (target) sha256;
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/libexec/claude-code/claude"
    makeBinaryWrapper "$out/libexec/claude-code/claude" "$out/bin/claude" \
      --inherit-argv0 \
      --set DISABLE_AUTOUPDATER 1 \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --set USE_BUILTIN_RIPGREP 0 \
      --prefix PATH : ${runtimePath}
    runHook postInstall
  '';

  meta = {
    description = "Claude Code - AI coding assistant in your terminal";
    homepage = "https://www.anthropic.com/claude-code";
    license = lib.licenses.unfree;
    platforms = builtins.attrNames targets;
    mainProgram = "claude";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
