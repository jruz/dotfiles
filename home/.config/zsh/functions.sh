is_linux() {
  [[ $('uname') == 'Linux' ]]
}

is_osx() {
  [[ $('uname') == 'Darwin' ]]
}

vpn() {
  region=$2
  if [[ $2 == "" ]]; then
    region="DE_Berlin"
  elif [[ $2 == "uk" ]]; then
    region="UK_London"
  elif [[ $2 == "us" ]]; then
    region="US_New_York_City"
  fi
  if [[ $1 == "list" ]]; then
    ls -1 --ignore=*.crt --ignore=*.pem /etc/openvpn/client/ | awk '{a=$2; gsub(".conf","",$1); print $1}'
    return 1
  fi
  sudo systemctl "$1" "openvpn-client@$region.service"
}

gri() {
  git rebase -i "HEAD~$1"
}

blu() {
  sudo systemctl start bluetooth.service
  echo -e 'power on\nquit' | bluetoothctl
  xmodmap ~/.Xmodmap
}

bl() {
  min=10
  max=1010
  let "val= $1*1010/10"
  if (($val > $max)); then
    val=$max
  elif (($val < $min)); then
    val=$min
  fi
  printf %.0f $val | sudo tee /sys/class/backlight/gmux_backlight/brightness
}

last_commit() {
  git --no-pager log -1 --pretty='format:%s'
}

tme() {
  $EDITOR "${HOME}/dev/dotfiles/.tmuxinator/$1.yml"
}

eject() {
  udisksctl unmount -b "$1" && udisksctl power-off -b "$1"
}

t() {
  if [[ $1 == "start" ]]; then
    transmission-daemon
  elif [[ $1 == "stop" ]]; then
    transmission-remote --exit
  elif [[ $1 == "status" ]]; then
    transmission-remote -l
  elif [[ $1 == "clear" ]]; then
    transmission-remote -t all -r
  elif [[ $1 == "cli" ]]; then
    transmission-remote-cli
  elif [[ $1 == "add" ]]; then
    transmission-remote -w /mnt/external/series -a "$2"
  fi
}

untar() {
  tar -xzvf "$1"
}

update_mirrorlist() {
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacold
  sudo mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
}

get_ip() {
  ip -4 a show "$1" | grep inet | awk '{print $2}' | sed 's/\/.*//'
}

wifi_ip() {
  get_ip enp0s20u1
}

cable_ip() {
  get_ip ens9
}

wifi_name() {
  iwconfig enp0s20u1 | grep ESSID: | awk '{print $4}' | sed -e 's/ESSID://' -e 's/"//g'
}

home_resolution() {
  xrandr --output eDP-1 --off
  xrandr --output DP-1 --mode 2560x1440
  xrandr --output DP-2 --mode 2560x1440 --rotate left --left-of DP-1
  xrandr --dpi 109
  xset r rate 180 40
  xmodmap ~/.Xmodmap
}

work_resolution() {
  xrandr --output eDP-1 --off
  xrandr --output DP-1 --mode 2560x1440
  xrandr --output HDMI-1 --mode 2560x1440 --rotate left --left-of DP-1
  xrandr --dpi 109
  xset r rate 180 40
  xmodmap ~/.Xmodmap
}

encrypt() {
  gpgtar -c --gpg-args --cipher-algo=AES256 -o "$1.gpg" "$1"
}

replace() {
  rg "$1"

  echo "\n\n"
  echo "s/$1/$2 (y/n)?"
  read REPLY
  if [[ $REPLY = "y" ]]; then
    rg -l "$1" | xargs -L 1 sed -i "s/$1/$2/g"
  fi
}

yf() {
  if is_osx; then
    cat "$1" | pbcopy
  elif is_linux; then
    xclip -sel clip <"$1"
  fi
}

yo() {
  if is_osx; then
    pbcopy
  elif is_linux; then
    xclip -sel clip
  fi
}

brain_path() {
  if is_osx; then
    echo "/Users/jruz/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain"
  elif is_linux; then
    echo "/mnt/c/Brain"
  fi
}

brain() {
  cd "$(brain_path)" || return
}

mp() {
  cd "$(brain_path)/🌞\ Morning\ Pages" || exit
}

colors() {
  awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm\033[38;2;%d;%d;%dm%s\033[0m", r,g,b, r,g,b, substr(s,colnum%8+1,1);
    }
    printf "\n";
  }'
}

ip-info() {
  local info public_ip local_ip dns_servers city region country

  info=$(curl -s https://ipinfo.io)
  public_ip=$(echo "$info" | jq -r '.ip')
  city=$(echo "$info" | jq -r '.city')
  region=$(echo "$info" | jq -r '.region')
  country=$(echo "$info" | jq -r '.country')

  if is_osx; then
    local_ip=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "not connected")
    dns_servers=$(scutil --dns | grep 'nameserver\[0\]' | head -1 | awk '{print $3}')
  else
    local_ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    dns_servers=$(grep '^nameserver' /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')
  fi

  echo "Public IP:  $public_ip"
  echo "Local IP:   $local_ip"
  echo "DNS:        $dns_servers"
  echo "Location:   $city, $region, $country"
}
