alias e = nvim

alias dotfiles = cd ~/dev/dotfiles
alias dot = cd ~/dev/dotfiles
alias dev = cd ~/dev/personal
alias dl = cd ~/Downloads
alias conf = cd ~/.config

alias al = nvim ~/.config/nushell/alias.nu
alias fu = nvim ~/.config/nushell/functions.nu

alias i3conf = nvim ~/.config/i3/config
alias i3sconf = nvim ~/.config/i3status/config
alias gconf = nvim ~/.config/ghostty/config
alias aconf = nvim ~/.config/alacritty/alacritty.toml
alias kconf = nvim ~/.config/kitty/kitty.conf
alias nvconf = nvim ~/.config/nvim/init.lua
alias vconf = nvim ~/.vimrc
alias tmconf = nvim ~/.tmux.conf
alias zshconf = nvim ~/.zshrc
alias econf = nvim ~/.config/doom
alias hconf = hx ~/.config/helix/config.toml
alias nuconf = nvim ~/.config/nushell
alias rtxconf = nvim ~/.config/rtx/config.toml
alias zeconf = nvim ~/.config/zellij/config.kdl
alias jt = just tmux
alias j = just
alias ze = zellij

alias rconf = sudo vim /boot/efi/EFI/refind/refind.conf
alias ngconf = sudo vim /etc/nginx/nginx.conf

alias hms = home-manager switch
alias hme = nvim ~/.config/home-manager/home.nix

alias off = shutdown -h now
alias x = exit
alias q = exit
alias p = sudo pacman -Sy
alias a = yay -Sya --nocleanmenu --noeditmenu --nodiffmenu --noremovemake --cleanafter
alias upp = sudo pacman -Syu
alias upa = pacaur -k
alias logs = journalctl -ef
alias dnsconf = sudo vim /etc/resolv.conf
alias disks = lsblk -o NAME,SIZE,FSTYPE,PARTLABEL,MOUNTPOINT -e 7
alias errors = journalctl -xe
alias sx = startx
alias sxe = startx ~/dev/dotfiles/X/home/.xinitrc
alias ag = rg -S --hidden

alias dhcr = sudo systemctl restart dhcpcd.service

alias eon = sudo ip link set dev ens9 up
alias eoff = sudo ip link set dev ens9 down

alias woff = nmcli radio wifi off
alias won = nmcli radio wifi on
alias ws = nmcli connection show
alias wa = netctl-auto current
alias wl = nmcli device wifi list ifname wlp0s20u1
alias wm = sudo wifi-menu enp0s20u1
alias wi = curl ipinfo.io

alias ls = lsd
alias la = lsd --almost-all --group-dirs=first --human-readable --long
alias las = lsd --almost-all --group-dirs=first --human-readable --long --dereference
alias lad = lsd --almost-all --group-dirs=first --human-readable --long --sort=time --reverse

alias hosts = sudo nvim /etc/hosts
alias cls = clear
alias .. = cd ..
alias ... = cd ../..
alias vimstall = vim +PluginInstall +qall

alias tma = tmux a -t
alias tmk = tmux kill-session -t
alias tms = tmuxinator start
alias tml = tmux ls

alias d = docker
alias dc = docker-compose
alias dps = docker ps
alias dpsa = docker ps -a
alias ds = docker start
alias dr = docker run
alias da = docker attach
alias k = kubectl

alias n = npm
alias tags = ctags -R --exclude=.git --exclude=node_modules
alias tf = terraform

alias g = git
alias ga = git add
alias gaa = git add -A
alias gap = git add -p
alias gb = git branch
alias gbc = git remote prune origin
alias gca = git commit --amend --no-edit
alias gcd = git checkout dev
alias gcm = git checkout main
alias gcmsg = git commit -m
alias gco = git checkout
alias gcob = git checkout -b
alias gcp = git cherry-pick
alias gcpc = git cherry-pick --continue
alias gcpn = git cherry-pick --no-commit
alias gd = git diff
alias gds = git diff --cached
alias gdd = git diff dev
alias gdl = git diff HEAD^ HEAD
alias gdm = git diff main
alias gf = git fetch
alias gmd = git merge dev
alias gpl = git pull --rebase
alias gps = git push
alias gpsf = git push --force
alias gr = git reset
alias grd = git rebase dev
alias grh = git reset HEAD~
alias grs = git rebase --skip
alias gs = git status
alias gst = git stash --include-untracked
alias gstp = git stash pop
alias gwip = git commit -m "WIP"

alias ubuntu = lsb_release -a
