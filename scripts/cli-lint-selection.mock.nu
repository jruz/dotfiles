#!/usr/bin/env nu

use std/log

const COMMAND = path self | path basename

if $env.CLI_TEST_MODE == "failure" {
    log error $"synthetic ($COMMAND) failure"
    exit 7
}
if $COMMAND == "fzf" {
    if $env.CLI_TEST_MODE == "cancel" { exit 130 }
    print "@1"
} else {
    {status: committed, message: "Synthetic commit"} | to json --raw | print
}
