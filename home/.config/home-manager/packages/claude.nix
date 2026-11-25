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
  version = "2.1.326";
  targets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "e214ad76dcc0e846b03be28ed1c2734aacd4e27acb527cb7f8a9e2bed644e837";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "98d56f6ffe53469767a74864a38eaf359d62ef557a8de1b1ad524d61a66ec119";
    };
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "b6b3647d981130dc44fc670846ae97b6cde531ffb667cf9c4d17cfcafb38cb37";
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
