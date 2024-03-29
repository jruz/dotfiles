alias e='$EDITOR'

# Config files
alias dotfiles='cd ~/dev/dotfiles'
alias dot='dotfiles'
alias dev='cd ~/dev/personal'
alias dl='cd ~/Downloads'
alias conf='cd ~/.config'

alias al='$EDITOR ~/.config/zsh/alias.sh'
alias fu='$EDITOR ~/.config/zsh/functions.sh'

alias i3conf='$EDITOR ~/.config/i3/config'
alias i3sconf='$EDITOR ~/.config/i3status/config'
alias aconf='$EDITOR ~/.config/alacritty/alacritty.yml'
alias kconf='$EDITOR ~/.config/kitty/kitty.conf'
alias nvconf='$EDITOR ~/.config/nvim/init.lua'
alias vconf='$EDITOR ~/.vimrc'
alias tmconf='$EDITOR ~/.tmux.conf'
alias zshconf='$EDITOR ~/.zshrc'
alias econf='$EDITOR ~/.config/doom'
alias hconf='$EDITOR ~/.config/helix/config.toml'
alias nuconf='$EDITOR ~/.config/nushell'
alias rtxconf='$EDITOR ~/.config/rtx/config.toml'
alias nu='nu --config ~/.config/nushell/config.nu'
alias jt="just tmux"
alias j="just"

alias rconf='sudo vim /boot/efi/EFI/refind/refind.conf'
alias ngconf='sudo vim /etc/nginx/nginx.conf'

# Home Manager
alias hms='home-manager switch'
alias hme='$EDITOR ~/.config/home-manager/home.nix'

# System
alias off='shutdown -h now'
alias x='exit'
alias q='exit'
alias p='sudo pacman -Sy'
alias a='yay -Sya --nocleanmenu --noeditmenu --nodiffmenu --noremovemake --cleanafter'
alias upp='sudo pacman -Syu'
alias upa='pacaur -k'
alias ups='$DOTFILES/update.sh'
alias logs='journalctl -ef'
alias dnsconf='sudo vim /etc/resolv.conf'
alias disks='lsblk -o NAME,SIZE,FSTYPE,PARTLABEL,MOUNTPOINT -e 7'
alias errors='journalctl -xe'
alias sx='startx'
alias sxe='startx ~/dev/dotfiles/X/home/.xinitrc'
alias ag='rg -S --hidden'
alias cat='bat'
alias awk='gawk'

# DHCP
alias dhcr='sudo systemctl restart dhcpcd.service'
alias dhcs='sudo systemctl status dhcpcd.service -l | grep -e "ens9\|enp0s02u1"'

# ETHERNET
alias eon='sudo ip link set dev ens9 up'
alias eoff='sudo ip link set dev ens9 down'

# WIFI
alias wr='nmcli radio wifi off && sleep 5 && nmcli radio wifi on'
alias woff='nmcli radio wifi off'
alias won='nmcli radio wifi on'
alias ws='nmcli connection show'
alias wa='netctl-auto current'
alias wl='nmcli device wifi list ifname wlp0s20u1'
alias wm='sudo wifi-menu enp0s20u1'
alias wi='curl ipinfo.io'
alias wip='wifi_ip'
alias wp='curl https://www.privateinternetaccess.com --silent | grep -Eo "<strong style=\"font-weight:bold;\">(.*)</strong>" | sed "s/<[^>]*>//g"'

# LS
alias ls='lsd'
alias las='ls -lAhtr --group-directories-first --color'
alias la='lsd --almost-all --group-dirs=first --human-readable --long'
alias lad='la --sort=time --reverse'

alias hosts='sudo $EDITOR /etc/hosts'
alias reload='. ~/.zshrc'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias vimstall='vim +PluginInstall +qall'

# Tmux
alias tma='tmux a -t'
alias tmk='tmux kill-session -t'
alias tms='tmuxinator start'
alias tml='tmux ls'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='d ps'
alias dpsa='d ps -a'
alias ds='d start'
alias dr='d run'
alias da='d attach'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" ${CID}'
alias k='kubectl'

# Other
alias n='npm'
alias tags='ctags -R --exclude=.git --exclude=node_modules'
alias tf='terraform'

# Git
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'
alias gb='git branch'
alias gbc='git remote prune origin'
alias gca='git commit --amend --no-edit'
alias gcd='git checkout develop'
alias gcm='git checkout main'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpn='git cherry-pick --no-commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdd='git diff develop'
alias gdl='git diff HEAD^ HEAD'
alias gdm='git diff main'
alias gdr='git diff origin/$(git rev-parse --abbrev-ref HEAD)'
alias gf='git fetch'
alias gl='git log --pretty=format:"%ad | %C(yellow)%h%C(reset) | %an | %C(blue)%s%C(reset) (%ar)" --date="short"'
alias gld='gl develop..$(git rev-parse --abbrev-ref HEAD)'
alias glm='gl main..$(git rev-parse --abbrev-ref HEAD)'
alias gmd='git merge develop'
alias gpl='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force'
alias gpsu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gr='git reset'
alias grc='GIT_EDITOR=true git rebase --continue'
alias grd='git rebase develop'
alias grh='git reset HEAD~'
alias grr='git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'
alias grm='git fetch && git rebase origin/main'
alias grs='git rebase --skip'
alias gs='git status'
alias gst='git stash --include-untracked'
alias gstp='git stash pop'
alias gwip='git commit -m "WIP"'
alias this_branch='git rev-parse --abbrev-ref HEAD'

# Ubuntu
alias ubuntu="lsb_release -a"
