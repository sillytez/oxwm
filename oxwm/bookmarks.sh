#!/bin/bash
# Rofi bookmarks mode for oxwm (used by the Mod+F, B chord).
# Prints "Title<TAB>URL" lines; rofi shows the title, we open the URL.
# Add your own bookmarks below — keep the format: Title<TAB>URL
cat <<'EOF'
GitHub	https://github.com
Hacker News	https://news.ycombinator.com
Arch Wiki	https://wiki.archlinux.org
Reddit	https://reddit.com
YouTube	https://youtube.com
EOF
