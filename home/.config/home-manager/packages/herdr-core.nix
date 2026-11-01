{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0.1.16";
  targets = {
    aarch64-darwin = {
      name = "macos-aarch64";
      sha256 = "698d8f0c44f4e4b15fec174d52a39d57a014cfd71added44b53a0753b469d0fd";
    };
    x86_64-darwin = {
      name = "macos-x86_64";
      sha256 = "6af081cdb35c8612c5752d3f64c6a378e6a0313968b6d4fbc4c03c95691b2872";
    };
    aarch64-linux = {
      name = "linux-aarch64";
      sha256 = "b6573137d70baff24fb346c957a9879af6bdc4c641188cdf9e47a7b2a677bc92";
    };
    x86_64-linux = {
      name = "linux-x86_64";
      sha256 = "58d6861176dc6fe905b58880d5bff07a9959be613a98e5d66b4583b04b6cfa45";
    };
  };
  target = targets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "herdr-core";
  inherit version;

  src = fetchurl {
    url = "https://releases.herdr.dev/core/${version}/herdr-core-${target.name}.tar.gz";
    inherit (target) sha256;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    tar --extract --gzip --file "$src" herdr-core
    install -Dm755 herdr-core "$out/bin/herdr-core"
    ln -s herdr-core "$out/bin/hc"
    runHook postInstall
  '';

  meta = {
    description = "Persistent terminal runtime for coding agents";
    homepage = "https://github.com/herdrdev/herdr-core";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames targets;
    mainProgram = "hc";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
