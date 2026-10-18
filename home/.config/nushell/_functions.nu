use log.nu

def is_linux [] {
    (uname).kernel-name == "Linux"
}

def is_osx [] {
    (uname).kernel-name == "Darwin"
}

def is_ssh [] {
    ($env | get --optional SSH_TTY) != null
}

def osc52_copy [] {
    let data = ($in | encode base64)
    print --no-newline $"\e]52;c;($data)\e\\"
}

def wr [] {
    nmcli radio wifi off
    sleep 5sec
    nmcli radio wifi on
}

def this_branch [] {
    git rev-parse --abbrev-ref HEAD
}

def gdr [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    git diff $"origin/($branch)"
}

def gl [
    range?: string
    --limit (-n): int = 15
] {
    let format = "%ad | %C(yellow)%h%C(reset) | %an | %C(blue)%s%C(reset) (%ar)"
    let args = [
        --pretty=format:($format)
        --date=short
        -n $"($limit)"
    ]

    if ($range | is-empty) {
        git log ...$args
    } else {
        git log ...$args $range
    }
}

def gld [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    gl $"dev..($branch)"
}

def glm [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    gl $"main..($branch)"
}

def grm [] {
    git fetch
    git rebase origin/main
}

def grc [] {
    with-env { GIT_EDITOR: "true" } { git rebase --continue }
}

def grr [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    git reset --hard $"origin/($branch)"
}

def gpsu [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    git push --set-upstream origin $branch
}

def gpsuf [] {
    let branch = (git rev-parse --abbrev-ref HEAD)
    git push --force --set-upstream origin $branch
}

def gri [count: int] {
    git rebase -i $"HEAD~($count)"
}

def last_commit [] {
    git --no-pager log -1 --pretty="format:%s"
}

def tme [name: string] {
    nvim $"($env.HOME)/dev/dotfiles/.tmuxinator/($name).yml"
}

def untar [file: string] {
    tar -xzvf $file
}

def encrypt [file: path] {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    ^age --encrypt --identity $identity --output $"($file).age" $file
}

def decrypt [file: path] {
    let identity = $"($env.HOME)/.config/sops/age/keys.txt"
    let output = ($file | str replace --regex '\.age$' '')
    ^age --decrypt --identity $identity --output $output $file
}

def get_ip [interface: string] {
    ip -4 a show $interface | lines | find inet | first | split row " " | get 1 | split row "/" | first
}

def wifi_ip [] {
    get_ip enp0s20u1
}

def cable_ip [] {
    get_ip ens9
}

def eject [device: string] {
    udisksctl unmount -b $device
    udisksctl power-off -b $device
}

def brain_path [] {
    if (is_osx) {
        "/Users/jruz/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain"
    } else {
        "/mnt/c/Brain"
    }
}

def --env brain [] {
    cd (brain_path)
}

def --env mp [] {
    cd $"(brain_path)/🌞 Morning Pages"
}

def yf [file: path] {
    if (is_osx) {
        open --raw $file | pbcopy
    } else if (is_ssh) {
        open --raw $file | osc52_copy
    } else {
        open --raw $file | xclip -sel clip
    }
}

def yo [] {
    if (is_osx) {
        $in | pbcopy
    } else if (is_ssh) {
        $in | osc52_copy
    } else {
        $in | xclip -sel clip
    }
}

def wh [command: string] {
    let which_result = (which $command)

    if ($which_result | any { |row| $row.type == "alias" }) {
        scope aliases | where name == $command | get expansion | first
    } else {
        $which_result
    }
}

def "nu-complete zellij-sessions" [] {
    ^zellij list-sessions
        | lines
        | each { |line|
            $line | ansi strip | split row " " | get 0
        }
        | where { |session| not ($session | is-empty) }
}

def "nu-complete tmux-sessions" [] {
    ^tmux list-sessions -F "#{session_name}"
        | lines
        | where { |session| not ($session | is-empty) }
}

def tma [session: string@"nu-complete tmux-sessions"] {
    ^tmux a -t $session
}

def tmk [session: string@"nu-complete tmux-sessions"] {
    ^tmux kill-session -t $session
}

def zk [session: string@"nu-complete zellij-sessions"] {
    ^procs $session --no-header --only pid | lines | each { |id| ^kill -9 $id }

    zellij delete-session -f $session
}

def za [session: string@"nu-complete zellij-sessions"] {
    zellij attach $session
}

def zel [] {
    let session_name = ($env.PWD | path basename | str upcase)
    zellij attach --create $session_name
}

def tmux-dev [] {
    let layout = if (is_osx) { "mac" } else { "mini" }
    ^tmuxinator start $layout
}

def rm [
    --recursive (-r)
    --force (-f)
    ...files: glob
] {
    let expanded = $files | flatten
    if (is_osx) {
        ^trash ...$expanded
    } else {
        ^trash-put ...$expanded
    }
}

def kill-port [port: int] {
    let pids = (^lsof -ti $":($port)" | lines | where { |line| not ($line | is-empty) })

    if ($pids | is-empty) {
        log warn $"No process found on port ($port)"
        return
    }

    $pids | each { |pid| ^kill -9 $pid }
    log ok $"Killed processes on port ($port)"
}

def zellij-mac [] {
    (just
        --justfile ~/dev/dotfiles/justfile
        --working-directory ~/dev/dotfiles
        zellij-generate-mac)
    zellij --new-session-with-layout mac --session MAC
}

def zellij-mini [] {
    (just
        --justfile ~/dev/dotfiles/justfile
        --working-directory ~/dev/dotfiles
        zellij-generate-mini)
    zellij --new-session-with-layout mini --session MINI
}
