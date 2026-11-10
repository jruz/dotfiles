export def --wrapped query [...args: string]: nothing -> string {
    let output = (^tmux ...$args)
    $output | str trim --right --char (char newline)
}

export def --wrapped tmux [...args: string]: nothing -> nothing {
    let output = query ...$args
    if $output != '' { print $output }
}

export def windows [session: string]: nothing -> table {
    query list-windows -t $session -F "#{window_id}\t#{window_active}\t#{window_name}"
    | lines
    | parse "{id}\t{active}\t{name}"
}

export def orphaned-windows []: table -> list<string> {
    group-by window --to-table
    | where ($it.items | all {|pane| $pane.sidebar == 'on' })
    | get window
}

export def select-window [window: string]: nothing -> nothing {
    tmux select-window -t $window
    let work = (query list-panes -t $window -F "#{pane_id}\t#{@sidebar}"
        | lines
        | parse "{id}\t{sidebar}"
        | where sidebar != 'on'
        | first)
    tmux select-pane -t $work.id
}
