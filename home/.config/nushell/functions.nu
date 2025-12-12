def is_linux [] {
    (uname).kernel-name == "Linux"
}

def is_osx [] {
    (uname).kernel-name == "Darwin"
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

def gl [range?: string] {
    if ($range | is-empty) {
        git log --pretty=format:"%ad | %C(yellow)%h%C(reset) | %an | %C(blue)%s%C(reset) (%ar)" --date="short"
    } else {
        git log --pretty=format:"%ad | %C(yellow)%h%C(reset) | %an | %C(blue)%s%C(reset) (%ar)" --date="short" $range
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

def brain [] {
    cd (brain_path)
}

def mp [] {
    cd $"(brain_path)/🌞 Morning Pages"
}

def yf [file: string] {
    if (is_osx) {
        open $file | pbcopy
    } else {
        open $file | xclip -sel clip
    }
}

def yo [] {
    if (is_osx) {
        $in | pbcopy
    } else {
        $in | xclip -sel clip
    }
}

