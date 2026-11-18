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
  version = "2.1.311";
  targets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "85d8c08707fcfd1e78ffa0204eefbc6ec9e4fe22f375fb2767ef85d957ed3161";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "2e2496c9a8065df93acb0fca2d341f59a6b8777649b2e025ab8c9bcd5eef61f3";
    };
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "86dc1fcc69498159eaf15f446613e847010f9036bfbbdffd4c49350be8489ada";
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
  pname = "claude";
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
