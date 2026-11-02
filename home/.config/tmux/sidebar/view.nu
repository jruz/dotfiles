use client.nu [query windows select-window]
use config.nu

const TOP_ROWS = 1

def selection-index []: record -> int {
    let state = $in
    $state.windows | get id | enumerate | where item == $state.selected | first | get index
}

def move-selection [delta: int]: record -> record {
    let state = $in
    let count = $state.windows | length
    let index = (($state | selection-index) + $delta + $count) mod $count
    $state | upsert selected ($state.windows | skip $index | first | get id)
}

def mouse-selection [event: record]: record -> record {
    let state = $in
    if $event.row < $TOP_ROWS { return $state }
    let index = $state.offset + $event.row - $TOP_ROWS
    if $index >= ($state.windows | length) { return $state }
    $state
    | upsert selected ($state.windows | skip $index | first | get id)
    | upsert activate true
}

export def transition [state: record, event: record]: nothing -> record {
    let next = $state | upsert activate false
    match $event {
        {type: key, key_type: f, code: '6'} => { $next | upsert focused true }
        {type: key, key_type: f, code: '7'} => { $next | upsert focused false }
        {type: key, code: up} | {type: key, code: k} => { $next | move-selection -1 }
        {type: key, code: down} | {type: key, code: j} => { $next | move-selection 1 }
        {type: key, code: enter} => { $next | upsert activate true }
        {type: focus, event: gained} => { $next | upsert focused true }
        {type: focus, event: lost} => { $next | upsert focused false }
        {type: mouse, kind: scroll_up} => { $next | move-selection -1 }
        {type: mouse, kind: scroll_down} => { $next | move-selection 1 }
        {type: mouse, kind: Left_down} => { $next | mouse-selection $event }
        _ => { $next }
    }
}

def scroll-offset [height: int]: record -> int {
    let state = $in
    let selected = $state | selection-index
    if $selected < $state.offset { return $selected }
    if $selected >= ($state.offset + $height) { return ($selected - $height + 1) }
    $state.offset
}

export def row [state: record, width: int]: record -> string {
    let window = $in
    let style = if $window.active == '1' {
        $state.theme.active
    } else if $state.focused and $window.id == $state.selected {
        $state.theme.selection
    } else {
        $state.theme.normal
    }
    let label = $" ($window.name)" | str substring 0..<$width | fill --width $width
    $"(ansi $style)($label)(ansi reset)"
}

def draw [state: record, size: record]: nothing -> nothing {
    let rows = ($state.windows
        | skip $state.offset
        | first ($size.rows - $TOP_ROWS)
        | each {|window| $window | row $state $size.columns }
        | str join "\r\n")
    let top = $"(ansi $state.theme.top)('' | fill --width $size.columns)(ansi reset)"
    print --no-newline $"(ansi cursor_home)(ansi $state.theme.normal)(ansi clear_screen_from_cursor_to_end)($top)\r\n($rows)(ansi reset)(ansi cursor_off)"
}

def refresh [session: string]: record -> record {
    let state = $in
    let updated = windows $session
    let selected = if $state.selected in ($updated | get id) {
        $state.selected
    } else {
        $updated | where active == '1' | first | get id
    }
    $state
    | upsert windows $updated
    | upsert selected $selected
    | upsert theme (config load).theme
}

def update [event: record, session: string]: record -> record {
    let state = $in
    match $event {
        {type: key, key_type: f, code: '5'} => { $state | refresh $session }
        _ => { transition $state $event }
    }
}

def event-loop [pane: string]: nothing -> nothing {
    let session = query display-message -p -t $pane '#{session_id}'
    let initial = windows $session
    mut state = {
        windows: $initial
        theme: (config load).theme
        selected: ($initial | where active == '1' | first | get id)
        focused: ((query display-message -p -t $pane '#{pane_active}') == '1')
        offset: 0
        activate: false
    }
    loop {
        let size = term size
        $state = $state | upsert offset ($state | scroll-offset ($size.rows - $TOP_ROWS))
        draw $state $size
        let event = input listen --types [key mouse focus resize]
        $state = $state | update $event $session
        if $state.activate {
            select-window $state.selected
            $state = $state | upsert focused false | upsert activate false
        }
    }
}

export def run [pane: string]: nothing -> nothing {
    print --no-newline $"(ansi --escape '?1049h')(ansi cursor_off)"
    try {
        event-loop $pane
    } catch {|err|
        print --no-newline $"(ansi reset)(ansi cursor_on)(ansi --escape '?1049l')"
        error make {msg: $err.msg}
    }
}
