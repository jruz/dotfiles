{
  lib,
  swiftPackages,
  swift,
  swiftpm,
  fetchFromGitHub,
}:

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "devicehubctl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ChrisThoma";
    repo = "devicehubctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nxgSnOTkoyaX9QgHG54H++49GVq/n55+oxH4yXaj/Vw=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 "$(swiftpmBinPath)/devicehubctl" "$out/bin/devicehubctl"
    runHook postInstall
  '';

  meta = {
    description = "Drive Xcode Device Hub simulators from the command line";
    homepage = "https://github.com/ChrisThoma/devicehubctl";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "devicehubctl";
  };
})
