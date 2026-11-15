use std/assert

const BIN = path self | path dirname | path dirname | path join home .local bin
const MOCK = path self cli-lint-regression.mock.nu
const SELECTION_MOCK = path self cli-lint-selection.mock.nu
const CONVERTER = path self | path dirname | path dirname | path join .claude skills starship convert-config

def fixture [commands: list<string>]: nothing -> path {
    let root = mktemp --directory
    mkdir ($root | path join bin)
    for command in $commands {
        let target = ($root | path join bin $command)
        let mock = if $command in [gum fzf] { $SELECTION_MOCK } else { $MOCK }
        cp $mock $target
        ^chmod +x $target
    }
    $root
}

def invoke [root: path, request: record<command: string, arguments: list<string>, mode: string>]: nothing -> record {
    with-env {
        PATH: ($env.PATH | prepend ($root | path join bin))
        CLI_TEST_ROOT: $root
        CLI_TEST_MODE: $request.mode
    } {
        ^nu ($BIN | path join $request.command) ...$request.arguments | complete
    }
}

def test-flac-converter-keeps-parallel-conversion-and-plain-logs []: nothing -> nothing {
    let root = fixture [ffmpeg]
    "track" | save ($root | path join first.flac)
    "track" | save ($root | path join second.flac)
    let result = invoke $root {command: ',flac-to-mp3', arguments: [$root], mode: success}
    assert equal $result.exit_code 0 $result.stderr
    assert str contains $result.stdout "Converted 2 files"
    assert str contains $result.stderr "Converting"
    assert not ($result.stderr | str contains "SeverityText")
    assert equal (glob ($root | path join mp3 '*.mp3') | length) 2
    rm --recursive $root
}

def test-flac-converter-reports-validation-and-command-failures []: nothing -> nothing {
    let root = fixture [ffmpeg]
    let empty = invoke $root {command: ',flac-to-mp3', arguments: [$root], mode: success}
    assert equal $empty.exit_code 1
    assert str contains $empty.stderr "no FLAC files"
    "track" | save ($root | path join track.flac)
    let failure = invoke $root {command: ',flac-to-mp3', arguments: [$root], mode: failure}
    assert ($failure.exit_code != 0)
    assert str contains $failure.stderr "synthetic ffmpeg failure"
    "existing" | save ($root | path join mp3 track.mp3)
    let collision = invoke $root {command: ',flac-to-mp3', arguments: [$root], mode: success}
    assert equal $collision.exit_code 1
    assert str contains $collision.stderr "output already exists"
    assert equal (open --raw ($root | path join mp3 track.mp3)) existing
    rm --recursive $root
}

def test-commit-wrapper-preserves-success-and-original-failure []: nothing -> nothing {
    let root = fixture [gum]
    let success = invoke $root {command: ',commit', arguments: [], mode: success}
    assert equal $success.exit_code 0 $success.stderr
    assert str contains $success.stdout "Synthetic commit"
    let failure = invoke $root {command: ',commit', arguments: [], mode: failure}
    assert ($failure.exit_code != 0)
    assert str contains $failure.stderr "synthetic gum failure"
    rm --recursive $root
}

def test-window-picker-preserves-cancellation-and-selection []: nothing -> nothing {
    let root = fixture [tmux fzf]
    let canceled = invoke $root {
        command: tmux-window-picker
        arguments: ['100']
        mode: cancel
    }
    assert equal $canceled.exit_code 0 $canceled.stderr
    assert not ($root | path join actions | path exists)
    let popup = invoke $root {
        command: tmux-window-picker
        arguments: [open client '100']
        mode: cancel
    }
    assert equal $popup.exit_code 0 $popup.stderr
    let selected = invoke $root {
        command: tmux-window-picker
        arguments: ['100']
        mode: success
    }
    assert equal $selected.exit_code 0 $selected.stderr
    assert str contains (open --raw ($root | path join actions)) select-window
    assert str contains (open --raw ($root | path join actions)) switch-client
    rm --recursive $root
}

def test-window-picker-preserves-preview-and-command-diagnostics []: nothing -> nothing {
    let root = fixture [tmux]
    let preview = invoke $root {
        command: tmux-window-picker
        arguments: [preview '%1']
        mode: success
    }
    assert equal $preview.exit_code 0 $preview.stderr
    assert equal $preview.stdout "Synthetic preview"
    let failure = invoke $root {
        command: tmux-window-picker
        arguments: [preview '%1']
        mode: failure
    }
    assert ($failure.exit_code != 0)
    assert str contains $failure.stderr "synthetic tmux failure"
    rm --recursive $root
}

def test-herdr-title-preserves-original-app-failure []: nothing -> nothing {
    let root = fixture [herdr-app]
    let failure = invoke $root {command: ',herdr-title', arguments: [Title], mode: failure}
    assert ($failure.exit_code != 0)
    assert str contains $failure.stderr "synthetic herdr-app failure"
    let empty = invoke $root {command: ',herdr-title', arguments: [''], mode: success}
    assert equal $empty.exit_code 1
    assert str contains $empty.stderr "provide a non-empty title"
    rm --recursive $root
}

def test-notify-rejects-invalid-target-without-network-access []: nothing -> nothing {
    let root = fixture []
    let result = invoke $root {
        command: ',notify'
        arguments: [invalid message]
        mode: success
    }
    assert equal $result.exit_code 1
    assert str contains $result.stderr "target must be mobile, desktop, or all"
    rm --recursive $root
}

def git-fixture []: nothing -> path {
    let root = fixture []
    cd $root
    ^git init --quiet
    ^git config user.name Test
    ^git config user.email test@example.invalid
    ^git config commit.gpgsign false
    ^git config core.hooksPath /dev/null
    "original" | save original.txt
    ^git add original.txt
    ^git commit --quiet --message "Initial fixture"
    $root
}

def test-git-wrappers-preserve-renames-passthrough-and-diagnostics []: nothing -> nothing {
    let root = git-fixture
    let original = pwd
    cd $root
    ^git mv original.txt renamed.txt
    "untracked" | save untracked.txt
    let grouped = invoke $root {command: gs, arguments: [], mode: success}
    assert equal $grouped.exit_code 0 $grouped.stderr
    assert str contains $grouped.stdout "original.txt → renamed.txt"
    assert str contains $grouped.stdout "untracked.txt"
    let passthrough = invoke $root {command: gs, arguments: [--short], mode: success}
    assert equal $passthrough.exit_code 0 $passthrough.stderr
    assert str contains $passthrough.stdout "R  original.txt -> renamed.txt"
    let commits = invoke $root {command: gl, arguments: [], mode: success}
    assert equal $commits.exit_code 0 $commits.stderr
    assert str contains $commits.stdout "Initial fixture"
    let unsupported = invoke $root {command: gl, arguments: [--oneline], mode: success}
    assert equal $unsupported.exit_code 1
    assert str contains $unsupported.stderr "Git output format is unsupported"
    let failure = invoke $root {
        command: gl
        arguments: [nonexistent-revision]
        mode: success
    }
    assert ($failure.exit_code != 0)
    assert str contains $failure.stderr "unknown revision"
    let invalid = invoke $root {
        command: gs
        arguments: [--invalid-status-flag]
        mode: success
    }
    assert ($invalid.exit_code != 0)
    assert str contains $invalid.stderr "unknown option"
    cd $original
    rm --recursive $root
}

def test-starship-converter-replaces-icons-through-public-command []: nothing -> nothing {
    let root = fixture []
    mkdir ($root | path join .claude skills starship) ($root | path join home .config)
    '{{ICON_OS_WINDOWS}}' | save ($root | path join .claude skills starship starship.toml)
    let original = pwd
    cd $root
    let result = (^nu $CONVERTER | complete)
    cd $original
    assert equal $result.exit_code 0 $result.stderr
    assert equal (open --raw ($root | path join home .config starship.toml)) (char --integer 0xF3B2)
    rm --recursive $root
}
