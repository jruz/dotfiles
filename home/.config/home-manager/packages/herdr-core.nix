{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0.1.22";
  targets = {
    aarch64-darwin = {
      name = "macos-aarch64";
      sha256 = "90798daadefa8d126b90ef0bcdbe9c7dda9c6cfbf011a247065ab5da348f350e";
    };
    aarch64-linux = {
      name = "linux-aarch64";
      sha256 = "98757985245d45f8d73dd85e68b139b7f167c28488bb89edd9834c3f5a5cf4cf";
    };
    x86_64-linux = {
      name = "linux-x86_64";
      sha256 = "3054ec3992ce80c5715d721caa9dcefa6056721d15dc113f4750afce763ba5df";
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
