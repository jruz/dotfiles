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

export def wr []: nothing -> string {
    ^nmcli radio wifi off
    sleep 5sec
    ^nmcli radio wifi on
}

export def gcmsg [message: string, --feat, --bugs, --refa, --deps, --tool, ...args: string]: nothing -> string {
    let types = ([
        (if $feat { "feat" })
        (if $bugs { "bugs" })
        (if $refa { "refa" })
        (if $deps { "deps" })
        (if $tool { "tool" })
    ] | compact)
    if ($types | length) > 1 {
        error make {msg: "gcmsg: specify only one commit type"}
    }
    let title = if ($types | is-empty) { $message } else { $"[($types | first)] ($message)" }
    ^git commit --message $title ...$args
}

def this-branch []: nothing -> string {
    ^git rev-parse --abbrev-ref HEAD
}

export def gdr []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git diff $"origin/($branch)"
}

export def gld []: nothing -> string {
    let branch = (this-branch | str trim)
    ^gl $"dev..($branch)"
}

export def glm []: nothing -> string {
    let branch = (this-branch | str trim)
    ^gl $"main..($branch)"
}

export def grm []: nothing -> string {
    ^git fetch
    ^git rebase origin/main
}

export def grc []: nothing -> string {
    with-env {GIT_EDITOR: "true"} { ^git rebase --continue }
}

export def grr []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git reset --hard $"origin/($branch)"
}

export def gpsu []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git push --set-upstream origin $branch
}

export def gpsuf []: nothing -> string {
    let branch = (this-branch | str trim)
    ^git push --force --set-upstream origin $branch
}

export def gri [count: int]: nothing -> string {
    ^git rebase --interactive $"HEAD~($count)"
}

export def last-commit []: nothing -> string {
    ^git --no-pager log --max-count 1 --pretty="format:%s"
}

export def tme [name: string]: nothing -> string {
    ^nvim $"($env.HOME)/dev/dotfiles/.tmuxinator/($name).yml"
}

export def untar [file: path]: nothing -> string {
    ^tar --extract --gzip --verbose --file $file
}

export def encrypt [file: path]: nothing -> nothing {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    ^age --encrypt --identity $identity --output $"($file).age" $file
}

export def decrypt [file: path]: nothing -> nothing {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    let output = ($file | str replace --regex '\.age$' '')
    ^age --decrypt --identity $identity --output $output $file
}

def get-ip [interface: string]: nothing -> string {
    let output = (^ip --json address show dev $interface)
    $output
    | from json
    | get addr_info
    | flatten
    | where family == "inet"
    | first
    | get local
}

export def wifi-ip []: nothing -> string {
    get-ip enp0s20u1
}

export def cable-ip []: nothing -> string {
    get-ip ens9
}

export def eject [device: string]: nothing -> string {
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

export def --env brain []: nothing -> nothing {
    cd (brain-path)
}

export def --env mp []: nothing -> nothing {
    cd $"(brain-path)/🌞 Morning Pages"
}

export def yf [file: path]: nothing -> nothing {
    let text = open --raw $file
    $text | yo
}

export def yo []: string -> nothing {
    if (is-osx) {
        $in | ^pbcopy
    } else if (is-ssh) {
        $in | osc52-copy
    } else {
        $in | ^xclip -selection clipboard
    }
}

export def wh [command: string]: nothing -> table {
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

export def tma [session: string@"nu-complete tmux-sessions"]: nothing -> string {
    ^tmux attach-session -t $session
}

export def tmk [session: string@"nu-complete tmux-sessions"]: nothing -> string {
    ^tmux kill-session -t $session
}

export def zk [session: string@"nu-complete zellij-sessions"]: nothing -> string {
    let output = (^procs $session --no-header --only pid)
    for id in ($output | lines) {
        ^kill -9 $id
    }
    ^zellij delete-session --force $session
}

export def za [session: string@"nu-complete zellij-sessions"]: nothing -> string {
    ^zellij attach $session
}

export def zel []: nothing -> string {
    let session_name = ($env.PWD | path basename | str upcase)
    ^zellij attach --create $session_name
}

export def tmux-dev []: nothing -> string {
    let layout = if (is-osx) { "mac" } else { "mini" }
    ^tmuxinator start $layout
}

export def zellij-mac []: nothing -> string {
    ^just --justfile ~/dev/dotfiles/justfile --working-directory ~/dev/dotfiles zellij-generate-mac
    ^zellij --new-session-with-layout mac --session MAC
}

export def zellij-mini []: nothing -> string {
    ^just --justfile ~/dev/dotfiles/justfile --working-directory ~/dev/dotfiles zellij-generate-mini
    ^zellij --new-session-with-layout mini --session MINI
}

export def gen-passphrase [words: int = 4]: nothing -> string {
    let phrase = (^xkcdpass --numwords $words --case capitalize --delimiter "-" --valid-chars '[a-z]'
        | str trim)
    let digit = (^shuf --random-source /dev/urandom --input-range 0-9 --head-count 1
        | str trim)
    $"($phrase)-($digit)"
}

export def gen-ssh-key [
    name: path
    --directory: path = ~/.ssh
    --no-passphrase
]: nothing -> string {
    let key_path = ($directory | path expand --no-symlink | path join $name)
    let passphrase_args = if $no_passphrase { ["-N" ""] } else { [] }
    ^ssh-keygen -t ed25519 -C $name -f $key_path ...$passphrase_args
}
