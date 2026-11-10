# List unique environment variable names from a file.
def main [
    file: path # File containing environment variable assignments.
]: nothing -> list<string> {
    open --raw $file
    | lines
    | parse --regex '^\s*(?:export\s+)?(?<name>[A-Za-z_][A-Za-z0-9_]*)\s*='
    | get name
    | uniq
    | sort
}
