{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.171.0";
  targets = {
    aarch64-darwin = {
      name = "aarch64-apple-darwin";
      sha256 = "9414c8c967f110b11e8324c0cfa2b20f012094ef890110a561c92ee535a2681a";
    };
    aarch64-linux = {
      name = "aarch64-unknown-linux-musl";
      sha256 = "bcf50b836385e51bd2976ab2bbe92b1b08a1cbe37712eb8dbe378aa78d24871c";
    };
    x86_64-linux = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "01baa2e47809f8597be5b2f8abd4e4dfe3fb5bcb6e504c2fbaaad97056c15e8d";
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
