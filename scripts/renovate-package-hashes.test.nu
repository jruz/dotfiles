use std/assert
use renovate-package-hashes.nu [missing-targets update-hashes]

const PACKAGE = '  targets = {
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "old-linux";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "old-darwin";
    };
  };
'

const HASHES = [
    [name sha256];
    [linux-x64 new-linux]
    [darwin-arm64 new-darwin]
    [win32-x64 new-windows]
]

def test-update-hashes-replaces-every-target []: nothing -> nothing {
    let updated = ($PACKAGE | update-hashes $HASHES)
    assert str contains $updated 'sha256 = "new-linux";'
    assert str contains $updated 'sha256 = "new-darwin";'
    assert not ($updated | str contains "old-")
}

def test-missing-targets-lists-targets-without-hashes []: nothing -> nothing {
    let hashes = [[name sha256]; [linux-x64 new-linux]]
    assert equal ($PACKAGE | missing-targets $hashes) [darwin-arm64]
}

def test-missing-targets-is-empty-when-all-hashes-exist []: nothing -> nothing {
    assert equal ($PACKAGE | missing-targets $HASHES) []
}
