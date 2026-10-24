def get-recipes []: nothing -> list<record> {
    let result = (^just --unstable --dump --dump-format json | complete)
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    let just_json = $result.stdout | from json
    [
        ...(
            $just_json.recipes
            | transpose recipe data
            | flatten
        )
        ...(
            $just_json.modules
            | transpose "module" data
            | flatten
            | select "module" recipes
            | each {|row| $row.recipes | items {|k, v|
                    {
                        recipe: ($"($row.module)::($k)" | str replace --regex '::default$' '')
                        ...$v
                    }
            } }
            | flatten
        )
    ]
    | where not $it.private
}

def "nu-complete just" []: nothing -> list<record> {
    get-recipes
        | select recipe doc parameters
        | each {|recipe|
            let name = $recipe.recipe
            mut desc = $recipe.doc | default " "
            for $p in $recipe.parameters {
              if ($p.default | is-empty) {
                  $desc += $" [(ansi blue)($p.name)(ansi reset)]"
              } else {
                  $desc += $" [(ansi blue)($p.name)='($p.default)'(ansi reset)]"
              }
            }
            {value: $name description: ($desc | str trim)}
        }
}

def "nu-complete just assignments" []: nothing -> list<record> {
    ^just --dump --dump-format json
    | from json
    | get assignments
    | transpose name value
    | each {|x| {
        value: $x.name,
        description: $"Current value: '($x.value.value)'"
    } }
}

export extern "just" [
    recipe?:string@"nu-complete just"
    --changelog
    --check
    --choose
    --clear-shell-args
    --dry-run(-n)
    --dump
    --edit(-e)
    --evaluate
    --explain
    --fmt
    --global-justfile(-g)
    --groups
    --highlight
    --init
    --list(-l)
    --man
    --no-aliases
    --no-deps
    --no-dotenv
    --no-highlight
    --one
    --quiet(-q)
    --shell-command
    --summary
    --tempdir:glob
    --timestamp
    --timestamp-format:string
    --unsorted(-u)
    --unstable
    --variables
    --verbose(-v)
    --yes
    --help(-h)
    --version(-V)

    --alias-style:string@"nu-complete just al-st"
    --chooser:string
    --color:string@"nu-complete just color-when"
    --command(-c):string
    --command-color:string@"nu-complete just color"
    --completions:string@"nu-complete just shells"
    --dotenv-filename:glob
    --dotenv-path(-E):glob
    --dump-format:string@"nu-complete just format"
    --justfile(-f):glob
    --list-heading:string
    --list-prefix:string
    --list-submodules
    --set:string@"nu-complete just assignments"
    --shell:string@"nu-complete just shells"
    --shell-arg:string
    --show(-s):string@"nu-complete just"
    --working-directory(-d):glob
]

def "nu-complete just al-st" []: nothing -> list<string> {
    [ "left" "right" "separate" ]
}

def "nu-complete just format" []: nothing -> list<string> {
    [ "just" "json" ]
}

def "nu-complete just shells" []: nothing -> list<string> {
    [ "zsh" "bash" "fish" "powershell" "elvish" "nushell" ]
}

def "nu-complete just color-when" []: nothing -> list<string> {
    [ "auto" "always" "never" ]
}

def "nu-complete just color" []: nothing -> list<string> {
    [ "black" "blue" "cyan" "green" "purple" "red" "yellow" ]
}
