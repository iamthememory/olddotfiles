#!/bin/sh

# Load /etc/X11/xinit/xinitrc.d/*
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for FILE in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "${FILE}" ] && source "${FILE}"
  done
  unset FILE
fi

eval $(gnome-keyring-daemon --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
export GPG_AGENT_INFO

# Activate Compose key
setxkbmap -model evdev -layout us -option compose:lwin

# Set up discrete GPU for render offloading and HDMI output.
#xrandr --setprovideroffloadsink radeon Intel
#xrandr --setprovideroutputsource radeon Intel

# Turn on numlock
numlockx on

# Set middle-click emulation
#xinput --set-prop "pointer:Logitech USB Receiver" "Evdev Middle Button Emulation" 1
#xinput --set-prop "pointer:Logitech Unifying Device. Wireless PID:400a" "Evdev Middle Button Emulation" 1
for i in {10..12}; do xinput --set-prop "$i" "Evdev Middle Button Emulation" 1; done

# Turn off touchpad
synclient TouchpadOff=1
xinput disable 'pointer:SynPS/2 Synaptics TouchPad'

# Hide mouse when idle
unclutter -idle 4 -jitter 5 -noevents -root &

# We need a compositing manager for DRI_PRIME=1 to work properly
# and to fix some video tearing
# Does this just make it worse?
#compton --config /home/iamthememory/.config/compton.conf -b &

# Polkit
/usr/libexec/polkit-gnome-authentication-agent-1 &

# Adjust display light timeouts
xset s off
xset dpms 1800 1800 1800

# Swap caps lock and escape
xmodmap ~/.speedswapper

# udiskie (udisks2 auto-mounter)
udiskie -2 -t &

# ownCloud sync
owncloud &

# Track keyboard, mouse statistics.
whatpulse &

# Set a background
feh --bg-center --randomize ~/.wallpaper/*

# Start pulseaudio.
start-pulseaudio-x11 &

# NetworkManager applet.
dbus-launch nm-applet &

# Blueman applet.
blueman-applet &

# Start i3wm w/consolekit
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
