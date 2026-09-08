# tez's Linux rice — oxwm + SDDM

My full Arch Linux ricing setup: the [oxwm](https://github.com/Rashad-707/oxwm) window
manager, a custom SDDM greeter theme, picom compositor, Alacritty terminal, and
xsecurelock lock screen — all sharing one GitHub-dark palette.

Everything is X11. No desktop environment — just WM + compositor + display manager.

## What I'm using

| Component | What | Notes |
|---|---|---|
| OS | Arch Linux | kernel printed live in the oxwm bar |
| Window manager | oxwm (AUR: `oxwm-git`) | Lua config, 9 tags, tiling/tabbed/normie layouts |
| Display manager | SDDM | custom "tez" greeter theme (QML) |
| Compositor | picom | glx backend — required for lock screen + terminal transparency |
| Terminal | Alacritty | JetBrainsMono Nerd Font 12, 0.85 opacity |
| Launcher | rofi | `drun`, `filebrowser`, and a custom bookmarks mode |
| Lock screen | xsecurelock | blurred screenshot of the live screen + mpv |
| Notifications | dunst | autostarted by oxwm |
| Screenshots | maim + xclip | region to clipboard, or file with Shift |
| Wallpaper | xwallpaper | autostarted by oxwm |
| Font | JetBrains Mono / JetBrainsMono Nerd Font | terminal, bar, greeter, lock screen |

## Palette

The one palette every component uses (GitHub dark):

| | hex |
|---|---|
| background | `#0d1117` |
| foreground | `#e6edf3` |
| green (accent) | `#7ee787` |
| blue | `#79c0ff` |
| purple | `#c0a6f0` |
| yellow | `#e3b341` |
| dim | `#8b949e` |

Alacritty is the source of truth — the oxwm bar and SDDM theme adopt its colors.

## Repo layout

```
alacritty/alacritty.toml      terminal config
oxwm/config.lua               window manager config (keys, bar, rules, autostart)
oxwm/lock.sh                  lock screen script (Mod+Shift+L)
oxwm/bookmarks.sh             rofi bookmarks mode (Mod+F then B)
picom/picom.conf              compositor config
sddm/tez/Main.qml             SDDM greeter theme
sddm/tez/theme.conf            theme colors
sddm/tez/metadata.desktop      theme metadata
sddm/tez/angle-down.png        dropdown arrow asset
sddm.conf.d/tez-theme.conf     SDDM theme selection (drop in /etc/sddm.conf.d/)
wallpaper.jpg                 the wallpaper (also used by the SDDM theme)
```

The SDDM theme lives in `sddm/tez/` here; on my machine it's deployed to
`/usr/share/sddm/themes/tez/` with the same files plus `background.jpg`.

## Dependencies

Core (pacman):

```bash
sudo pacman -S --needed alacritty picom sddm rofi dunst \
  xsecurelock maim xclip imagemagick mpv playerctl \
  brightnessctl xwallpaper pactl
```

- `pactl` comes from `pulseaudio`/`pipewire-pulse` (volume keys)
- `mpv`, `maim`, `imagemagick` are used by the lock screen script
- Font: `ttf-jetbrains-mono-nerd` (pacman)

AUR:

```bash
paru -S oxwm-git   # the window manager itself
```

## Install (manual)

1. Clone and copy the configs:

   ```bash
   git clone https://github.com/sillytez/oxwm-sddm.git
   cd oxwm-sddm

   mkdir -p ~/.config
   cp -r alacritty  ~/.config/
   cp -r oxwm       ~/.config/
   cp -r picom      ~/.config/
   chmod +x ~/.config/oxwm/lock.sh ~/.config/oxwm/bookmarks.sh
   ```

2. Wallpaper — the oxwm autostart expects `~/walls/whysoetude247.jpg`:

   ```bash
   mkdir -p ~/walls
   cp wallpaper.jpg ~/walls/whysoetude247.jpg
   ```

   (or edit the `xwallpaper` line at the bottom of `~/.config/oxwm/config.lua`)

3. SDDM theme — copy to the system themes dir and select it:

   ```bash
   sudo mkdir -p /usr/share/sddm/themes/tez
   sudo cp sddm/tez/* /usr/share/sddm/themes/tez/
   sudo cp wallpaper.jpg /usr/share/sddm/themes/tez/background.jpg
   sudo cp sddm.conf.d/tez-theme.conf /etc/sddm.conf.d/
   ```

   Make sure SDDM runs on X11 (`/etc/sddm.conf`: `DisplayServer=x11`).

4. Enable SDDM and reboot into oxwm:

   ```bash
   sudo systemctl enable sddm
   ```

   Pick oxwm in the SDDM session menu. oxwm also ships
   `/usr/share/xsessions/oxwm.desktop` so the session shows up automatically.

5. Log in — picom, xwallpaper, and dunst start from the oxwm autostart at the
   bottom of `config.lua`.

## Keybinds (oxwm)

| Keys | Action |
|---|---|
| Mod + Enter | terminal (Alacritty) |
| Mod + D | rofi app launcher |
| Mod + F, then B / F / O | rofi bookmarks / launcher / file browser |
| Mod + Shift + L | lock screen |
| Mod + S / Shift+S | screenshot to clipboard / to file |
| Mod + H/L | shrink/grow master |
| Mod + J/K, Shift+J/K | cycle/move focus in stack |
| Mod + 1..9 / Shift+1..9 | view tag / move window to tag |
| Mod + C / N | set tiling / cycle layout |
| Mod + A | toggle gaps |
| Mod + Shift + F / Space | fullscreen / floating |
| Mod + , / . | focus / move between monitors |
| Mod + Shift + R | restart oxwm |

`Mod` is Super (Mod4). Volume and brightness media keys are bound too.

## Notes / gotchas

- **picom must use the glx backend** (`picom.conf` here): the xrender backend
  draws over xsecurelock's windows and breaks the lock screen.
- Alacritty is excluded from picom shadows and unredirecting, so its 0.85
  opacity keeps working while fullscreen apps unredirect.
- xsecurelock color values need the `#` prefix (`#0d1117`, not `0d1117`) —
  XAllocNamedColor fails silently otherwise and you get a black-on-black
  auth box.
- The lock screen's font is plain `JetBrains Mono` (not the Nerd Font) —
  Xft rejects color fonts.
- My terminal config is also published separately at
  [sillytez/alacritty-config](https://github.com/sillytez/alacritty-config).
