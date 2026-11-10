#!/usr/bin/env nu

def shortcuts [table: string, prefix: string]: nothing -> table<key: string, description: string> {
    let output = (^tmux list-keys -N -P $prefix -T $table)
    ($output
        | lines
        | parse --regex '^\s*(?<key>\S+)\s+(?<description>.+)$')
}

def cell []: record<key: string, description: string> -> string {
    let shortcut = $in
    let key = $shortcut.key | fill --width 12
    let description = $shortcut.description | fill --width 38
    $"(ansi cyan_bold)($key)(ansi reset)($description)"
}

def main []: nothing -> nothing {
    let bindings = (shortcuts prefix '' | append (shortcuts root ''))
    let height = ($bindings | length) / 2 | math ceil | into int
    let columns = $bindings | chunks $height
    print $"\n  (ansi white)Ctrl+a first · arrows below need no prefix(ansi reset)\n"
    for row in ($columns.0 | enumerate) {
        let left = $row.item | cell
        let right = if $row.index < ($columns.1 | length) {
            $columns.1 | skip $row.index | first | cell
        } else {
            ''
        }
        print $"  ($left)  ($right)"
    }
    print $"\n  (ansi white)Esc / q to close(ansi reset)"
    loop {
        let event = input listen --types [key]
        if $event.code in [esc q] {
            break
        }
    }
}
