#!/usr/bin/env nu

use client.nu [query tmux orphaned-windows]
use config.nu
use view.nu

const SELF = path self

def main []: nothing -> nothing {
    print 'Usage: main.nu setup|toggle WINDOW; enable SESSION; refresh; reload; prune; render'
}

def pane-list [window: string]: nothing -> table {
    query list-panes -t $window -F "#{pane_id}\t#{@sidebar}\t#{pane_current_path}"
    | lines
    | parse "{id}\t{sidebar}\t{path}"
}

def all-panes []: nothing -> table {
    query list-panes -a -F "#{window_id}\t#{pane_id}\t#{@sidebar}"
    | lines
    | parse "{window}\t{id}\t{sidebar}"
}

def setup [window: string]: nothing -> nothing {
    let panes = pane-list $window
    if ($panes | any {|pane| $pane.sidebar == 'on' }) { return }
    let name = query display-message -p -t $window '#{window_name}'
    if ($name | str starts-with 'z:') { return }
    let active = query display-message -p -t $window '#{pane_id}'
    let work = $panes | first
    let settings = config load
    if ($panes | length) == 1 {
        tmux split-window -h -d -t $work.id -c $work.path
    }
    let sidebar = (query split-window -h -b -f -d -l ($settings.width | into string) -t $work.id -P -F '#{pane_id}'
        nu --no-config-file $SELF render)
    tmux set-option -p -t $sidebar @sidebar on
    tmux select-pane -t $active
}

def "main refresh" []: nothing -> nothing {
    for pane in (all-panes | where sidebar == 'on') {
        tmux send-keys -t $pane.id F5
    }
}

def "main reload" []: nothing -> nothing {
    let settings = config load
    for pane in (all-panes | where sidebar == 'on') {
        tmux resize-pane -t $pane.id -x ($settings.width | into string)
        tmux send-keys -t $pane.id F5
    }
}

def "main prune" []: nothing -> nothing {
    for window in (all-panes | orphaned-windows) {
        tmux kill-window -t $window
    }
}

def "main render" []: nothing -> nothing {
    try {
        view run $env.TMUX_PANE
    } catch {|err|
        print --stderr $"[ERROR] ($err.msg)"
        exit 1
    }
}

# Set up the sidebar in a tmux window.
def "main setup" [
    window: string # Target tmux window ID.
]: nothing -> nothing {
    setup $window
    main refresh
}

# Toggle the sidebar in a tmux window.
def "main toggle" [
    window: string # Target tmux window ID.
]: nothing -> nothing {
    let sidebars = pane-list $window | where sidebar == 'on'
    if ($sidebars | is-empty) {
        setup $window
        return
    }
    for pane in $sidebars {
        tmux kill-pane -t $pane.id
    }
}

# Enable sidebars in every window of a tmux session.
def "main enable" [
    session: string # Target tmux session ID.
]: nothing -> nothing {
    let windows = query list-windows -t $session -F '#{window_id}' | lines
    for window in $windows {
        setup $window
    }
    main refresh
}
