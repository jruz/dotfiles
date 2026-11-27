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
      host = {
        name = "code-mode-host-aarch64-apple-darwin";
        sha256 = "7a05606c29b08cc44b50689e9aa3ec17f766a726abd6105cc9fa5306ee6335a7";
      };
    };
    aarch64-linux = {
      name = "aarch64-unknown-linux-musl";
      sha256 = "bcf50b836385e51bd2976ab2bbe92b1b08a1cbe37712eb8dbe378aa78d24871c";
      host = {
        name = "code-mode-host-aarch64-unknown-linux-musl";
        sha256 = "7669c881b78669b5f13ddb99996b5cef3fb10dab5b69f43be31d19e82e9cd62b";
      };
    };
    x86_64-linux = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "01baa2e47809f8597be5b2f8abd4e4dfe3fb5bcb6e504c2fbaaad97056c15e8d";
      host = {
        name = "code-mode-host-x86_64-unknown-linux-musl";
        sha256 = "d78619030c1b8d0a4d9c9c67667c1bfa23ad9d9edc63d87ffeaa86796f3d868c";
      };
    };
  };
  target = targets.${stdenv.hostPlatform.system};
  release = asset: {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${asset.name}.tar.gz";
    inherit (asset) sha256;
  };
in
stdenv.mkDerivation {
  pname = "codex";
  inherit version;

  srcs = [
    (fetchurl (release target))
    (fetchurl (release target.host))
  ];

  sourceRoot = ".";
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "codex-${target.name}" "$out/bin/codex"
    install -Dm755 "codex-${target.host.name}" "$out/bin/codex-code-mode-host"
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
