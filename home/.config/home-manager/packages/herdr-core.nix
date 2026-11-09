{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0.1.19";
  targets = {
    aarch64-darwin = {
      name = "macos-aarch64";
      sha256 = "5338d900adadb6d273b9c8e97027247db3179ccffede10a1793358f16e08d683";
    };
    x86_64-darwin = {
      name = "macos-x86_64";
      sha256 = "2f95bedae2ca1bf9f9611d61066ef3ac211c62ca08282132d48e287b6da14d08";
    };
    aarch64-linux = {
      name = "linux-aarch64";
      sha256 = "f95c34fd7177ed58807d74fe4ee78bb3dc73eb37f21c69496064000a21abcb10";
    };
    x86_64-linux = {
      name = "linux-x86_64";
      sha256 = "4adcfb423d52f24c5cc4a1e2cd2fcad1f62d28bb77876ac472c29082a3eaa424";
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
