use client.nu query

export def load []: nothing -> record {
    let background = query show-options -gv @sidebar-background
    let foreground = query show-options -gv @sidebar-foreground
    let highlight_background = query show-options -gv @sidebar-highlight-background
    let highlight_foreground = query show-options -gv @sidebar-highlight-foreground
    {
        width: (query show-options -gv @sidebar-width | into int)
        theme: {
            normal: {fg: $foreground, bg: $background}
            selection: {fg: $highlight_foreground, bg: $highlight_background}
            active: {fg: $highlight_foreground, bg: $highlight_background, attr: b}
            top: {bg: (query show-options -gv @sidebar-top-background)}
        }
    }
}
