def is-linux []: nothing -> bool {
    (uname).kernel-name == "Linux"
}

def is-osx []: nothing -> bool {
    (uname).kernel-name == "Darwin"
}

def is-ssh []: nothing -> bool {
    $env.SSH_TTY? != null
}

def osc52-copy []: string -> nothing {
    let data = ($in | encode base64)
    print --no-newline $"\e]52;c;($data)\e\\"
}

def wr []: nothing -> string {
    ^nmcli radio wifi off
    sleep 5sec
    ^nmcli radio wifi on
}

def this-branch []: nothing -> string {
    ^git rev-parse --abbrev-ref HEAD
}

def gdr []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git diff $"origin/($branch)"
}

def gl [range?: string, --limit (-n): int = 15]: nothing -> string {
    let format = "%ad | %C(yellow)%h%C(reset) | %an | %C(blue)%s%C(reset) (%ar)"
    let args = [
        --pretty=format:($format)
        --date=short
        --max-count $limit
    ]
    match $range {
        null => { ^git log ...$args }
        _ => { ^git log ...$args $range }
    }
}

def gld []: nothing -> string {
    let branch = (this-branch | str trim)
    gl $"dev..($branch)"
}

def glm []: nothing -> string {
    let branch = (this-branch | str trim)
    gl $"main..($branch)"
}

def grm []: nothing -> string {
    ^git fetch
    ^git rebase origin/main
}

def grc []: nothing -> string {
    with-env {GIT_EDITOR: "true"} { ^git rebase --continue }
}

def grr []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git reset --hard $"origin/($branch)"
}

def gpsu []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git push --set-upstream origin $branch
}

def gpsuf []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git push --force --set-upstream origin $branch
}

def gri [count: int]: nothing -> string {
    ^git rebase --interactive $"HEAD~($count)"
}

def last-commit []: nothing -> string {
    ^git --no-pager log --max-count 1 --pretty="format:%s"
}

def tme [name: string]: nothing -> string {
    ^nvim $"($env.HOME)/dev/dotfiles/.tmuxinator/($name).yml"
}

def untar [file: path]: nothing -> string {
    ^tar --extract --gzip --verbose --file $file
}

def encrypt [file: path]: nothing -> nothing {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    ^age --encrypt --identity $identity --output $"($file).age" $file
}

def decrypt [file: path]: nothing -> nothing {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    let output = ($file | str replace --regex '\.age$' '')
    ^age --decrypt --identity $identity --output $output $file
}

def get-ip [interface: string]: nothing -> string {
    let result = (^ip --json address show dev $interface | complete)
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    $result.stdout
    | from json
    | get addr_info
    | flatten
    | where family == "inet"
    | first
    | get local
}

def wifi-ip []: nothing -> string {
    get-ip enp0s20u1
}

def cable-ip []: nothing -> string {
    get-ip ens9
}

def eject [device: string]: nothing -> string {
    ^udisksctl unmount --block-device $device
    ^udisksctl power-off --block-device $device
}

def brain-path []: nothing -> string {
    if (is-osx) {
        "/Users/jruz/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain"
    } else {
        "/mnt/c/Brain"
    }
}

def --env brain []: nothing -> nothing {
    cd (brain-path)
}

def --env mp []: nothing -> nothing {
    cd $"(brain-path)/🌞 Morning Pages"
}

def yf [file: path]: nothing -> nothing {
    let text = open --raw $file
    $text | yo
}

def yo []: string -> nothing {
    if (is-osx) {
        $in | ^pbcopy
    } else if (is-ssh) {
        $in | osc52-copy
    } else {
        $in | ^xclip -selection clipboard
    }
}

def wh [command: string]: nothing -> table {
    let result = (which $command)
    if ($result | any {|row| $row.type == "alias" }) {
        scope aliases | where name == $command | select name expansion
    } else {
        $result
    }
}

def "nu-complete zellij-sessions" []: nothing -> list<string> {
    ^zellij list-sessions
    | lines
    | ansi strip
    | parse --regex '^(?<name>\S+)'
    | get name
}

def "nu-complete tmux-sessions" []: nothing -> list<string> {
    ^tmux list-sessions -F "#{session_name}"
    | lines
    | where ($it | is-not-empty)
}

def tma [session: string@"nu-complete tmux-sessions"]: nothing -> string {
    ^tmux attach-session -t $session
}

def tmk [session: string@"nu-complete tmux-sessions"]: nothing -> string {
    ^tmux kill-session -t $session
}

def zk [session: string@"nu-complete zellij-sessions"]: nothing -> string {
    let result = (^procs $session --no-header --only pid | complete)
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    for id in ($result.stdout | lines) {
        ^kill -9 $id
    }
    ^zellij delete-session --force $session
}

def za [session: string@"nu-complete zellij-sessions"]: nothing -> string {
    ^zellij attach $session
}

def zel []: nothing -> string {
    let session_name = ($env.PWD | path basename | str upcase)
    ^zellij attach --create $session_name
}

def tmux-dev []: nothing -> string {
    let layout = if (is-osx) { "mac" } else { "mini" }
    ^tmuxinator start $layout
}

def rm [...files: glob, --_force (-f), --_recursive (-r)]: nothing -> nothing {
    let expanded = ($files | flatten)
    if (is-osx) {
        ^trash ...$expanded
    } else {
        ^trash-put ...$expanded
    }
}

def kill-port [port: int]: nothing -> nothing {
    use lib/logger.nu
    let result = (^lsof -ti $":($port)" | complete)
    if $result.exit_code == 1 and ($result.stdout | is-empty) {
        logger warn $"No process found on port ($port)"
        return
    }
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    for pid in ($result.stdout | lines) {
        ^kill -9 $pid
    }
    logger ok $"Killed processes on port ($port)"
}

def zellij-mac []: nothing -> string {
    ^just --justfile ~/dev/dotfiles/justfile --working-directory ~/dev/dotfiles zellij-generate-mac
    ^zellij --new-session-with-layout mac --session MAC
}

def zellij-mini []: nothing -> string {
    ^just --justfile ~/dev/dotfiles/justfile --working-directory ~/dev/dotfiles zellij-generate-mini
    ^zellij --new-session-with-layout mini --session MINI
}

def gen-passphrase [words: int = 4]: nothing -> string {
    let phrase = (^xkcdpass --numwords $words --case capitalize --delimiter "-" --valid-chars '[a-z]'
        | str trim)
    let digit = (^shuf --random-source /dev/urandom --input-range 0-9 --head-count 1
        | str trim)
    $"($phrase)-($digit)"
}
