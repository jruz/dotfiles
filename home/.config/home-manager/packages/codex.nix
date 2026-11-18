{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.170.0";
  targets = {
    aarch64-darwin = {
      name = "aarch64-apple-darwin";
      sha256 = "7c9f21d5cbae4860d14b379fdcf709ff399ce874fd714b58783e1b4199c2b9a9";
    };
    aarch64-linux = {
      name = "aarch64-unknown-linux-musl";
      sha256 = "0da6b061f6b5223901a5a73e841bd1466596e2ef620d68823360febed2ff7ebc";
    };
    x86_64-linux = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "d054916ccd28a53820376b8d2f7c875184ca8f40fcd44bbabeb8ee240ce247f5";
    };
  };
  target = targets.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  pname = "codex";
  inherit version;

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${target.name}.tar.gz";
    inherit (target) sha256;
  };

  sourceRoot = ".";
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "codex-${target.name}" "$out/bin/codex"
    runHook postInstall
  '';

  meta = {
    description = "Codex - OpenAI coding agent in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames targets;
    mainProgram = "codex";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
