#!/bin/sh

# Load /etc/X11/xinit/xinitrc.d/*
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for FILE in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "${FILE}" ] && source "${FILE}"
  done
  unset FILE
fi

# Load xprofile.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

# Start i3wm w/consolekit
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
