{ pkgs }:

let
  version = "0.2.1";
  isDarwin = pkgs.stdenv.isDarwin;
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;

  src =
    if isDarwin && isAarch64 then
      pkgs.fetchurl {
        url = "https://github.com/dphaener/zellijinator/releases/download/v${version}/zellijinator_Darwin_arm64.tar.gz";
        sha256 = "f5fae9baaf17f2adf4e2c450bb98b03e727237a5afb20c271a6e4e9350c58de4";
      }
    else if isDarwin then
      pkgs.fetchurl {
        url = "https://github.com/dphaener/zellijinator/releases/download/v${version}/zellijinator_Darwin_x86_64.tar.gz";
        sha256 = "b032dc6dc43ee045a45fad5d56f06282bdcb07eb6245b2de18f8163202a05193";
      }
    else
      pkgs.fetchurl {
        url = "https://github.com/dphaener/zellijinator/releases/download/v${version}/zellijinator_Linux_x86_64.tar.gz";
        sha256 = "78858ae960299acc23ee50f4be92807357f39a47a109b321a5632af470486e72";
      };
in
pkgs.stdenv.mkDerivation {
  pname = "zellijinator";
  inherit version src;

  nativeBuildInputs = [ pkgs.gnutar ];

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zellijinator $out/bin/
    chmod +x $out/bin/zellijinator
  '';

  meta = {
    description = "A tmuxinator-like session manager for Zellij";
    homepage = "https://github.com/dphaener/zellijinator";
    license = pkgs.lib.licenses.mit;
    mainProgram = "zellijinator";
  };
}
