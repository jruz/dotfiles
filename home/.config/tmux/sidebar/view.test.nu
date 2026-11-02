use std/assert
use view.nu [row transition]
use client.nu orphaned-windows

const THEME = {
    normal: {fg: '#cdd6f4', bg: '#1e1e2e'}
    selection: {fg: '#1e1e2e', bg: '#b4befe'}
    active: {fg: '#1e1e2e', bg: '#b4befe', attr: b}
    top: {bg: '#000000'}
}

const WINDOWS = [
    {id: '@1', active: '1', name: editor}
    {id: '@2', active: '0', name: server}
]

def state []: nothing -> record {
    {
        windows: $WINDOWS
        theme: $THEME
        selected: '@1'
        focused: false
        offset: 0
        activate: false
    }
}

def test-row-spacing []: nothing -> nothing {
    let rendered = $WINDOWS.0 | row (state) 20 | ansi strip
    assert equal $rendered (' editor' | fill --width 20)
    assert equal ($WINDOWS.0 | row (state) 4 | ansi strip) ' edi'
}

def test-row-highlights []: nothing -> nothing {
    let highlight = ansi $THEME.selection
    let active = ansi $THEME.active
    let focused = state | upsert selected '@2' | upsert focused true
    assert ($WINDOWS.0 | row (state) 20 | str starts-with $active)
    assert ($WINDOWS.0 | row $focused 20 | str starts-with $active)
    assert ($WINDOWS.1 | row $focused 20 | str starts-with $highlight)
    assert not ($WINDOWS.1 | row (state) 20 | str starts-with $highlight)
}

def test-keyboard-selection []: nothing -> nothing {
    let moved = transition (state) {type: key, code: down}
    assert equal $moved.selected '@2'
    assert equal (transition $moved {type: key, code: down}).selected '@1'
    assert equal (transition (state) {type: key, code: up}).selected '@2'
    assert (transition $moved {type: key, code: enter}).activate
}

def test-focus []: nothing -> nothing {
    let focused = transition (state) {type: key, key_type: f, code: '6'}
    assert $focused.focused
    assert not (transition $focused {type: key, key_type: f, code: '7'}).focused
    assert not (transition $focused {type: focus, event: lost}).focused
}

def test-mouse-selection []: nothing -> nothing {
    let clicked = transition (state) {type: mouse, kind: Left_down, row: 2}
    assert equal $clicked.selected '@2'
    assert $clicked.activate
    assert not (transition (state) {type: mouse, kind: Left_down, row: 0}).activate
    assert equal (transition (state) {type: mouse, kind: Left_down, row: 1}).selected '@1'
    assert not (transition (state) {type: mouse, kind: Left_down, row: 5}).activate
}

def test-configurable-theme []: nothing -> nothing {
    let theme = $THEME | upsert selection {fg: '#ffffff', bg: '#000000'}
    let focused = state | upsert theme $theme | upsert selected '@2' | upsert focused true
    let rendered = $WINDOWS.1 | row $focused 20
    assert ($rendered | str starts-with (ansi $theme.selection))
}

def test-orphan-cleanup []: nothing -> nothing {
    let panes = [
        {window: '@1', sidebar: on}
        {window: '@1', sidebar: ''}
        {window: '@2', sidebar: on}
        {window: '@3', sidebar: ''}
    ]
    assert equal ($panes | orphaned-windows) ['@2']
    assert equal ([] | orphaned-windows) []
}

def main []: nothing -> nothing {
    test-row-spacing
    test-row-highlights
    test-keyboard-selection
    test-focus
    test-mouse-selection
    test-configurable-theme
    test-orphan-cleanup
    print '7 sidebar tests passed'
}
