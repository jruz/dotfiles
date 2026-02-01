{ pkgs }:

pkgs.buildGo124Module rec {
  pname = "mcp-language-server";
  version = "0.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "isaacphi";
    repo = "mcp-language-server";
    rev = "v${version}";
    hash = "sha256-T0wuPSShJqVW+CcQHQuZnh3JOwqUxAKv1OCHwZMr7KM=";
  };

  vendorHash = "sha256-3NEG9o5AF2ZEFWkA9Gub8vn6DNptN6DwVcn/oR8ujW0=";

  subPackages = [ "." ];

  meta = {
    description = "MCP server providing LSP capabilities";
    homepage = "https://github.com/isaacphi/mcp-language-server";
    license = pkgs.lib.licenses.mit;
    mainProgram = "mcp-language-server";
  };
}
