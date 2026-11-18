#!/usr/bin/env nu

use std/log

const PACKAGES = path self ../home/.config/home-manager/packages
const SUPPORTED = [claude codex herdr-core]

def versions []: string -> list<string> {
    parse --regex 'version = "(?<version>[^"]+)";' | get version
}

def package-targets []: string -> table<name: string, sha256: string> {
    parse --regex 'name = "(?<name>[^"]+)";\s+sha256 = "(?<sha256>[^"]+)";'
}

def claude-hashes [version: string]: nothing -> table<name: string, sha256: string> {
    http get $"https://downloads.claude.ai/claude-code-releases/($version)/manifest.json"
    | get platforms
    | items {|name, platform| {name: $name, sha256: $platform.checksum} }
}

def codex-hashes [version: string]: nothing -> table<name: string, sha256: string> {
    http get $"https://api.github.com/repos/openai/codex/releases/tags/rust-v($version)"
    | get assets
    | where name =~ '^codex-.+\.tar\.gz$'
    | each {|asset|
        {
            name: ($asset.name | str replace --regex '^codex-(.+)\.tar\.gz$' '$1')
            sha256: ($asset.digest | str replace 'sha256:' '')
        }
    }
}

def herdr-core-hashes [version: string]: nothing -> table<name: string, sha256: string> {
    http get $"https://releases.herdr.dev/core/($version)/manifest.json"
    | get targets
    | items {|name, target| {name: $name, sha256: $target.sha256} }
}

def release-hashes [package: string, version: string]: nothing -> table<name: string, sha256: string> {
    match $package {
        "claude" => (claude-hashes $version)
        "codex" => (codex-hashes $version)
        "herdr-core" => (herdr-core-hashes $version)
    }
}

export def missing-targets [hashes: table<name: string, sha256: string>]: string -> list<string> {
    let available = ($hashes | get name)
    $in | package-targets | get name | where $it not-in $available
}

export def update-hashes [hashes: table<name: string, sha256: string>]: string -> string {
    mut updated = $in
    for target in ($updated | package-targets) {
        let sha256 = ($hashes | where name == $target.name | get sha256 | first)
        $updated = ($updated | str replace $target.sha256 $sha256)
    }
    $updated
}

# Refresh the per-platform sha256 of a package for its current version.
def main [
    package: string # Package file name in home/.config/home-manager/packages.
]: nothing -> nothing {
    if $package not-in $SUPPORTED {
        log error $"Unknown package: ($package). Use one of: ($SUPPORTED | str join ', ')"
        exit 1
    }
    let file = ($PACKAGES | path join $"($package).nix")
    let content = (open --raw $file)
    let declared = ($content | versions)
    if ($declared | is-empty) {
        log error $"($file) has no version declaration"
        exit 1
    }
    let version = ($declared | first)
    let hashes = (release-hashes $package $version)
    let missing = ($content | missing-targets $hashes)
    if ($missing | is-not-empty) {
        log error $"($package) ($version) has no hash for: ($missing | str join ', ')"
        exit 1
    }
    $content | update-hashes $hashes | save --force $file
}
