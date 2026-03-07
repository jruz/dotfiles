{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "deff";
  version = "0.1.1";

  src = unstable.fetchFromGitHub {
    owner = "flamestro";
    repo = "deff";
    rev = "main";
    hash = "sha256-wMdd4UOPpVq+KwO0/Jhs6XYy6MhnOz5Y9L7e49PkzVU=";
  };

  cargoHash = "sha256-9HleEVGpp0KJ4A5cuDN7FK3rJbY+liqrmXLr+Ox4AIk=";

  meta = {
    description = "Interactive side-by-side git diff reviewer";
    homepage = "https://github.com/flamestro/deff";
    license = unstable.lib.licenses.mit;
    mainProgram = "deff";
  };
}
