{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "deff";
  version = "0.1.1";

  src = unstable.fetchFromGitHub {
    owner = "flamestro";
    repo = "deff";
    rev = "main";
    hash = "sha256-CZl9KDeBVo8qgYZNgQST8ThBwA7C6WjG3Dn1IE2nw7g=";
  };

  cargoHash = "sha256-9HleEVGpp0KJ4A5cuDN7FK3rJbY+liqrmXLr+Ox4AIk=";

  meta = {
    description = "Interactive side-by-side git diff reviewer";
    homepage = "https://github.com/flamestro/deff";
    license = unstable.lib.licenses.mit;
    mainProgram = "deff";
  };
}
