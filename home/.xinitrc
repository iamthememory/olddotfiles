#!/bin/sh

# Load /etc/X11/xinit/xinitrc.d/*
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for FILE in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "${FILE}" ] && source "${FILE}"
  done
  unset FILE
fi

# Activate Compose key
setxkbmap -model evdev -layout us -option compose:lwin

# Set up discrete GPU for render offloading and HDMI output.
xrandr --setprovideroffloadsink radeon Intel
xrandr --setprovideroutputsource radeon Intel

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

# Run jackd off of pulseaudio (jackd can't handle the speaker/subwoofer as of
# linux ~3.13).
#pulseaudio &
#sleep 3
#jackd --realtime --nozombies --driver=pulse --rate=96000 --device="hw:0" &

# Start pulseaudio to run off jack. Give it a second to capture the sound card.
#sleep 3
#pulseaudio -L module-jack-sink -L module-jack-source &
pulseaudio -L module-alsa-sink -L module-alsa-source &

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

# Redshift
#redshift -v >> ~/.redshift.log &

# IRC notify listener
notify-listener.py &

# udiskie (udisks2 auto-mounter)
udiskie -2 -t &

# ownCloud sync
owncloud &

# Track keyboard, mouse statistics.
whatpulse &

# Set a background
feh --bg-center --randomize ~/.wallpaper/*

# Start i3wm w/consolekit
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
