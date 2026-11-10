def shell-path []: nothing -> string {
    if (uname).kernel-name == "Darwin" {
        "/run/current-system/sw/bin/nu"
    } else {
        $"($env.HOME)/.nix-profile/bin/nu"
    }
}

def registered-shells []: nothing -> list<string> {
    open /etc/shells | lines
}

# Set Nushell as the login shell.
def main []: nothing -> nothing {
    let shell_path = shell-path
    if $shell_path not-in (registered-shells) {
        print $"Adding ($shell_path) to /etc/shells..."
        $"($shell_path)\n" | ^sudo tee --append /etc/shells # nu-lint-ignore: dangerous_file_operations
    }
    print $"Changing shell to ($shell_path)..."
    print "You may be prompted for your password:"
    ^chsh -s $shell_path
    print "Shell changed! Restart your terminal for it to take effect."
}
