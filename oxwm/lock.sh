#!/bin/bash
# tez's lock screen — xsecurelock
#   • snapshot + blur of current screen (via saver_mpv still image)
#   • time + date in the auth window (native)
#   • password field with asterisks per character
#   • theme colors: dark bg, light fg
#
# NOTE: requires picom on the glx backend (xrender draws over the lock
# windows — see picom.conf).

IMG="/tmp/lockscreen-$(id -u).png"

# Screenshot and blur (privacy: hide content behind blur)
maim "$IMG" 2>/dev/null || {
    magick -size 1920x1080 xc:'#0d1117' "$IMG"
}
magick "$IMG" -blur 0x8 -fill black -colorize 25% "$IMG"

# mpv plays the still image fullscreen as the "screensaver" background
export XSECURELOCK_SAVER=saver_mpv
export XSECURELOCK_LIST_VIDEOS_COMMAND="printf '%s\n' '$IMG'"
export XSECURELOCK_IMAGE_DURATION_SECONDS=999999
export XSECURELOCK_VIDEOS_FLAGS="--no-input-default-bindings --really-quiet"

export XSECURELOCK_PASSWORD_PROMPT=asterisks
export XSECURELOCK_SHOW_DATETIME=1
export XSECURELOCK_DATETIME_FORMAT='%a %b %d %H:%M'
export XSECURELOCK_FONT='JetBrains Mono:size=18'
export XSECURELOCK_AUTH_BACKGROUND_COLOR='#0d1117'
export XSECURELOCK_AUTH_FOREGROUND_COLOR='#e6edf3'
export XSECURELOCK_COMPOSITE_OBSCURER=0
export XSECURELOCK_PAM_SERVICE=system-auth

xsecurelock

rm -f "$IMG"
