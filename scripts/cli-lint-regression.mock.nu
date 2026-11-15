#!/usr/bin/env nu

use std/log

const COMMAND = path self | path basename

def --wrapped main [
    ...arguments: string # Arguments passed to the mocked executable.
]: nothing -> nothing {
    let mode = $env.CLI_TEST_MODE
    if $mode == "failure" {
        log error $"synthetic ($COMMAND) failure"
        exit 7
    }
    match $COMMAND {
        "ffmpeg" => {
            let destination = ($arguments | last)
            let name = ($destination | path basename)
            "started" | save ($env.CLI_TEST_ROOT | path join $"($name).started")
            let deadline = (date now) + 5sec
            while (glob ($env.CLI_TEST_ROOT | path join '*.started') | length) < 2 {
                if (date now) > $deadline {
                    log error "Conversions did not overlap"
                    exit 1
                }
                sleep 10ms
            }
            "converted" | save $destination
        }
        "tmux" => {
            match $arguments.0 {
                "list-windows" => { print "@1\t$1\tSession\t●\t1\tWindow" }
                "show-options" => { print 80 }
                "display-popup" => { if $mode == "cancel" { exit 1 } }
                "capture-pane" => { print "Synthetic preview" }
                "select-window" | "switch-client" => {
                    $arguments | to nuon | save --append ($env.CLI_TEST_ROOT | path join actions)
                }
            }
        }
    }
}
