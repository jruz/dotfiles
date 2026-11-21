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
  version = "2.1.323";
  targets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "5432918d904a9b6afef7bb79d20df24d76052eabc1f41bceb84091d21f8889a7";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "452dddff140b5caf00a5410333a3d6db82c73ea2dec74b1541fae18e97d47dca";
    };
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "604d29a6869409106b6a1110bdadcc8b72e8654a5a865d23258f938a696e348e";
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
