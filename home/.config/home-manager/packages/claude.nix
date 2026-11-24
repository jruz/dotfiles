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
  version = "2.1.325";
  targets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "84590fefe6338be9087f5814b61f9a54c5f21524163a4c127cb5a808e31009f2";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "7b6e484b1989a5a14a4b354709ccc8672518a3ec5b9ccd7981fc6254327fde67";
    };
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "0dc4f4a9a165fc60746d7ae8489712e5fc352f1e7ad4eb22e7141bd0812eb0cf";
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
