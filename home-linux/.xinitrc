#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X12/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#twm &
#xclock -geometry 50x50-1+1
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login

#---- keyboard repat speed
xset r rate 180 40
xsetroot -solid black

#---- RETINA
xrandr --dpi 168

#---- HOME
#xrandr --output eDP-1 --off
#xrandr --output DP-1 --mode 2560x1440
#xrandr --output DP-2 --mode 2560x1440 --rotate left --left-of DP-1
#xrandr --dpi 109

#---- MEINDACH
#xrandr --output eDP-1 --off
#xrandr --output DP-1 --mode 2560x1440
#xrandr --output HDMI-1 --mode 2560x1440 --rotate left --left-of DP-1
#xrandr --dpi 109

#---- start i3
exec i3
#exec gnome-session
