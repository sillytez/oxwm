# tez's Linux rice — oxwm + SDDM

<p align="center">
  <img src="wallpaper.jpg" width="600" alt="tezs wallpaper">
</p>

<p align="center">
  <a href="https://github.com/tonybanters/oxwm"><img alt="oxwm" src="https://img.shields.io/badge/WM-oxwm-c0a6f0?style=flat"></a>
  <img alt="X11" src="https://img.shields.io/badge/X11-only-0d1117?style=flat">
  <img alt="GitHub Dark" src="https://img.shields.io/badge/palette-GitHub_Dark-0d1117?style=flat&labelColor=0d1117&color=7ee787">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-blue?style=flat">
</p>

> A complete X11 ricing setup: the [oxwm](https://github.com/tonybanters/oxwm) window
> manager, a custom SDDM greeter theme, picom compositor, Alacritty terminal, and
> xsecurelock lock screen — all sharing one cohesive GitHub-dark palette.
>
> No desktop environment — just WM + compositor + display manager.

| | |
|---|---|
| 🪟 **WM** | [oxwm](https://github.com/tonybanters/oxwm) — Lua config, 9 tags, tiling/tabbed/normie layouts |
| 🔐 **Display manager** | SDDM with a custom "tez" QML greeter theme |
| ✨ **Compositor** | picom (glx backend — required for lock screen + terminal transparency) |
| 🖥️ **Terminal** | Alacritty — JetBrainsMono Nerd Font 12, 0.85 opacity |
| 🔍 **Launcher** | rofi — `drun`, `filebrowser`, and a custom bookmarks mode |
| 🔒 **Lock screen** | xsecurelock — blurred screenshot of the live screen + mpv |
| 🔔 **Notifications** | dunst — autostarted by oxwm |
| 📸 **Screenshots** | maim + xclip — region to clipboard, or file with Shift |
| 🖼️ **Wallpaper** | xwallpaper — autostarted by oxwm |
| 🔤 **Font** | JetBrains Mono / JetBrainsMono Nerd Font — everywhere |

## 🎨 Palette

The one palette every component uses (GitHub dark):

| Color | Hex | | Preview |
|---|---|---|---|
| background | `#0d1117` | | ![](https://img.shields.io/badge/-%20-0d1117?style=flat-square) |
| foreground | `#e6edf3` | | ![](https://img.shields.io/badge/-%20-e6edf3?style=flat-square) |
| green (accent) | `#7ee787` | | ![](https://img.shields.io/badge/-%20-7ee787?style=flat-square) |
| blue | `#79c0ff` | | ![](https://img.shields.io/badge/-%20-79c0ff?style=flat-square) |
| purple | `#c0a6f0` | | ![](https://img.shields.io/badge/-%20-c0a6f0?style=flat-square) |
| yellow | `#e3b341` | | ![](https://img.shields.io/badge/-%20-e3b341?style=flat-square) |
| red | `#ff7b72` | | ![](https://img.shields.io/badge/-%20-ff7b72?style=flat-square) |
| cyan | `#96d3e6` | | ![](https://img.shields.io/badge/-%20-96d3e6?style=flat-square) |
| dim | `#8b949e` | | ![](https://img.shields.io/badge/-%20-8b949e?style=flat-square) |

Alacritty is the source of truth — the oxwm bar and SDDM theme adopt its colors.

## 📋 Table of contents

- [Repo layout](#repo-layout)
- [Install](#install)
  - [1. Dependencies](#1-dependencies)
  - [2. oxwm](#2-oxwm)
  - [3. The configs](#3-the-configs)
  - [4. SDDM theme](#4-sddm-theme)
- [Step-by-step per distro](#step-by-step-per-distro)
- [Using the pieces with a different WM or DE](#using-the-pieces-with-a-different-wm-or-de)
  - [Window Managers](#window-managers)
  - [Desktop Environments](#desktop-environments)
- [Keybinds (oxwm)](#keybinds-oxwm)
- [Notes / gotchas](#notes--gotchas)

## 📁 Repo layout

```
alacritty/alacritty.toml        terminal config
oxwm/config.lua                 window manager config (keys, bar, rules, autostart)
oxwm/lock.sh                    lock screen script (Mod+Shift+L)
oxwm/bookmarks.sh               rofi bookmarks mode (Mod+F then B)
picom/picom.conf                compositor config
sddm/tez/Main.qml               SDDM greeter theme
sddm/tez/theme.conf             theme colors
sddm/tez/metadata.desktop       theme metadata
sddm/tez/angle-down.png         dropdown arrow asset
sddm.conf.d/tez-theme.conf      SDDM theme selection (drop in /etc/sddm.conf.d/)
wallpaper.jpg                   the wallpaper (also used by the SDDM theme)
```

The SDDM theme lives in `sddm/tez/` here; on my machine it's deployed to
`/usr/share/sddm/themes/tez/` with the same files plus `background.jpg`.

## 📦 Install

### 1. Dependencies

Every component here is packaged on basically every distro except oxwm itself
(see below). Package names by distro:

| Component | Arch | Artix | Manjaro | Debian/Ubuntu | Fedora | RHEL/Rocky/Alma | Void | openSUSE | Gentoo | Alpine | NixOS |
|---|---|---|---|---|---|---|---|---|---|---|---|
| alacritty | `alacritty` | `alacritty` | `alacritty` | `alacritty` | `alacritty` | `alacritty` (EPEL) | `alacritty` | `alacritty` | `alacritty` | `alacritty` | `alacritty` |
| picom | `picom` | `picom` | `picom` | `picom` | `picom` | (build from source) | `picom` | `picom` | `picom` | `picom` | `picom` |
| sddm | `sddm` | `sddm` | `sddm` | `sddm` | `sddm` | `sddm` (EPEL) | `sddm` | `sddm` | `sddm` | `sddm` | `sddm` |
| rofi | `rofi` | `rofi` | `rofi` | `rofi` | `rofi` | `rofi` (EPEL) | `rofi` | `rofi` | `rofi` | `rofi` | `rofi` |
| dunst | `dunst` | `dunst` | `dunst` | `dunst` | `dunst` | `dunst` (EPEL) | `dunst` | `dunst` | `dunst` | `dunst` | `dunst` |
| xsecurelock | `xsecurelock` | `xsecurelock` | `xsecurelock` | `xsecurelock` | `xsecurelock` | (build from source) | `xsecurelock` | (build from source) | `xsecurelock` | (build from source) | `xsecurelock` |
| maim + xclip | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` (EPEL) | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` |
| imagemagick | `imagemagick` | `imagemagick` | `imagemagick` | `imagemagick` | `ImageMagick` | `ImageMagick` | `ImageMagick` | `ImageMagick` | `imagemagick` | `imagemagick` | `imagemagick` |
| mpv | `mpv` | `mpv` | `mpv` | `mpv` | `mpv` | `mpv` (EPEL/RPM Fusion) | `mpv` | `mpv` | `mpv` | `mpv` | `mpv` |
| playerctl | `playerctl` | `playerctl` | `playerctl` | `playerctl` | `playerctl` | `playerctl` (EPEL) | `playerctl` | `playerctl` | `playerctl` | `playerctl` | `playerctl` |
| brightnessctl | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` (EPEL) | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` |
| xwallpaper | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` | (build from source) | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` |
| pipewire-pulse | `pipewire-pulse` | `pipewire-pulse` | `pipewire-pulse` | `pipewire` | `pipewire-pulse` | `pipewire-pulse` | `pipewire` | `pipewire` | `pipewire` | `pipewire` | `pipewire` |
| font | `ttf-jetbrains-mono-nerd` | `ttf-jetbrains-mono-nerd` | `ttf-jetbrains-mono-nerd` | `fonts-jetbrains-mono` (no nerd glyphs) | `jetbrains-mono-fonts` + nerd font from AUR-like source | `jetbrains-mono-fonts` (EPEL) + nerd font manual | nerd-fonts-ttf from [nerdfonts.com](https://www.nerdfonts.com) | `jetbrains-mono-fonts` | `media-fonts/jetbrains-mono` | `font-jetbrains-mono-nerd` | `(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })` |

JetBrainsMono Nerd Font is the only awkward one — if your distro doesn't package
it, grab the release tarball from
[nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads) and drop
it in `/usr/local/share/fonts/` (or `~/.local/share/fonts/`), then `fc-cache -f`.

<details>
<summary>One-liner installs per distro</summary>

```bash
# Arch
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd

# Debian / Ubuntu
sudo apt install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire fonts-jetbrains-mono

# Fedora
sudo dnf install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse jetbrains-mono-fonts

# Void
sudo xbps-install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper \
  pipewire

# openSUSE
sudo zypper install alacritty picom sddm rofi dunst \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper pipewire

# Artix (same as Arch — uses pacman + AUR)
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd
paru -S oxwm-git    # AUR helper (or yay)

# Gentoo
sudo emerge alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire media-fonts/jetbrains-mono

# Alpine
sudo apk add alacritty picom sddm rofi dunst maim xclip imagemagick \
  mpv playerctl brightnessctl xwallpaper pipewire font-jetbrains-mono-nerd
# xsecurelock — build from source on Alpine (not in main/community)

# Manjaro (same as Arch — uses pacman + AUR)
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd
paru -S oxwm-git    # AUR helper (or yay)

# RHEL / Rocky / Alma
sudo dnf install epel-release
sudo dnf install alacritty sddm rofi dunst maim xclip ImageMagick \
  mpv playerctl brightnessctl pipewire-pulse jetbrains-mono-fonts
# xsecurelock, picom, xwallpaper — build from source on RHEL family

# NixOS (in configuration.nix or a flake)
#   Add to environment.systemPackages:
#   alacritty picom sddm rofi dunst xsecurelock maim xclip
#   imagemagick mpv playerctl brightnessctl xwallpaper
#   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
#   See the "NixOS" section under oxwm above for building oxwm from source
```
</details>

### 2. oxwm

Arch has it in the AUR:

```bash
paru -S oxwm-git        # or: yay -S oxwm-git
```

Elsewhere, build from source. oxwm is Zig, so install a Zig toolchain first
(`zig` — packaged on Arch/Fedora/VOID as `zig`, Debian as `zig`):

```bash
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

Debian/Ubuntu users: install `zig` from
[ziglang.org/download](https://ziglang.org/download/) (the distro package is
often too old) or use [andrewrk's PPA-free static builds](https://ziglang.org/download/).

<details>
<summary>NixOS</summary>

oxwm isn't in nixpkgs — build it from source with a custom derivation:

```nix
# flake.nix or configuration.nix
{ pkgs, ... }:
let
  oxwm = pkgs.stdenv.mkDerivation {
    pname = "oxwm";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "tonybanters";
      repo = "oxwm";
      rev = "main";          # pin to a specific commit for reproducibility
      hash = "";             # let it fail once, then paste the correct hash
    };
    nativeBuildInputs = [ pkgs.zig ];
    buildPhase = "zig build -Doptimize=ReleaseFast";
    installPhase = "zig build -Doptimize=ReleaseFast --prefix $out";
  };
in {
  environment.systemPackages = with pkgs; [
    oxwm
    # deps (see the dependency table above — all are in nixpkgs):
    alacritty picom sddm rofi dunst xsecurelock maim xclip
    imagemagick mpv playerctl brightnessctl xwallpaper
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
```

> **oxwm.desktop / xsession:** oxwm ships an `oxwm.desktop` xsession file so it
> appears in SDDM's session menu automatically. If it doesn't, add it manually
> to `/usr/share/xsessions/` (or the nixpkgs equivalent in
> `/run/current-system/sw/share/xsessions/`).

</details>

### 3. The configs

```bash
git clone https://github.com/sillytez/oxwm.git
cd oxwm

mkdir -p ~/.config
cp -r alacritty  ~/.config/
cp -r oxwm       ~/.config/
cp -r picom      ~/.config/
chmod +x ~/.config/oxwm/lock.sh ~/.config/oxwm/bookmarks.sh
```

Wallpaper — the oxwm autostart expects `~/walls/whysoetude247.jpg`:

```bash
mkdir -p ~/walls
cp wallpaper.jpg ~/walls/whysoetude247.jpg
```

(or edit the `xwallpaper` line at the bottom of `~/.config/oxwm/config.lua`)

### 4. SDDM theme

Copy to the system themes dir and select it:

```bash
sudo mkdir -p /usr/share/sddm/themes/tez
sudo cp sddm/tez/* /usr/share/sddm/themes/tez/
sudo cp wallpaper.jpg /usr/share/sddm/themes/tez/background.jpg
sudo cp sddm.conf.d/tez-theme.conf /etc/sddm.conf.d/
```

Make sure SDDM runs on X11 (`/etc/sddm.conf`: `DisplayServer=x11`), then:

```bash
sudo systemctl enable sddm
```

Pick oxwm in the SDDM session menu on the greeter. oxwm ships an
`oxwm.desktop` xsession file so it appears automatically.

<details>
<summary>NixOS — SDDM theme</summary>

NixOS doesn't use `/usr/share/sddm/themes/` — everything goes through the Nix
store. Package the theme as a derivation and point SDDM at it:

```nix
# in your configuration.nix or a custom module
{ pkgs, ... }:
let
  tez-sddm-theme = pkgs.stdenv.mkDerivation {
    pname = "sddm-theme-tez";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "sillytez";
      repo = "oxwm";
      rev = "main";
      hash = "";             # let it fail once, then paste the correct hash
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/tez
      cp -r sddm/tez/* $out/share/sddm/themes/tez/
      cp wallpaper.jpg $out/share/sddm/themes/tez/background.jpg
    '';
  };
in {
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "tez";
  };
  environment.systemPackages = [ tez-sddm-theme ];
}
```

</details>

<details>
<summary>No display manager? startx instead</summary>

If you don't want SDDM (or any DM), use xinit. Create `~/.xinitrc`:

```bash
# ~/.xinitrc
exec dbus-launch oxwm
```

Then `startx` from the TTY. picom/xwallpaper/dunst still start from oxwm's
autostart, so nothing else is needed. (On Arch: `sudo pacman -S xorg-xinit`.)
</details>

## 📝 Step-by-step per distro

Each tab walks through the full install end to end: dependencies → oxwm →
configs → SDDM theme. If you just want a quick package list, see the
one-liner installs above.

<details>
<summary>Arch Linux</summary>

**1. Dependencies**

```bash
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd
```

**2. oxwm** (from the AUR)

```bash
paru -S oxwm-git        # or: yay -S oxwm-git
```

**3. Configs**

```bash
git clone https://github.com/sillytez/oxwm.git
cd oxwm
mkdir -p ~/.config
cp -r alacritty ~/.config/
cp -r oxwm      ~/.config/
cp -r picom     ~/.config/
chmod +x ~/.config/oxwm/lock.sh ~/.config/oxwm/bookmarks.sh
mkdir -p ~/walls
cp wallpaper.jpg ~/walls/whysoetude247.jpg
```

**4. SDDM theme**

```bash
sudo mkdir -p /usr/share/sddm/themes/tez
sudo cp sddm/tez/* /usr/share/sddm/themes/tez/
sudo cp wallpaper.jpg /usr/share/sddm/themes/tez/background.jpg
sudo cp sddm.conf.d/tez-theme.conf /etc/sddm.conf.d/
sudo systemctl enable sddm
```

Log out, pick oxwm in the SDDM session menu, log in.

</details>

<details>
<summary>Artix Linux</summary>

Same as Arch — Artix uses pacman and the AUR. The only difference is the
init system (Artix uses OpenRC/runit/s6/dinit instead of systemd), so
`systemctl enable sddm` becomes:

**1. Dependencies**

```bash
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd
paru -S oxwm-git
```

**2. Configs** — same as Arch (see above)

**3. SDDM** — same copy steps as Arch, then enable with your init:

```bash
sudo rc-update add sddm default        # OpenRC
# or: sudo ln -s /etc/runit/sv/sddm /run/runit/service/   # runit
# or: sudo s6-rc-bundle add sddm                           # s6
# or: sudo dinitctl enable sddm                            # dinit
```

</details>

<details>
<summary>Manjaro</summary>

Same as Arch — Manjaro uses pacman and the AUR, and ships with systemd.

**1. Dependencies**

```bash
sudo pacman -S --needed alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse ttf-jetbrains-mono-nerd
pamac build oxwm-git      # or: paru -S oxwm-git / yay -S oxwm-git
```

**2. Configs** — same as Arch (see above)

**3. SDDM** — same as Arch (see above), `sudo systemctl enable sddm`

</details>

<details>
<summary>Debian / Ubuntu</summary>

**1. Dependencies**

```bash
sudo apt update
sudo apt install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire fonts-jetbrains-mono
```

> **Note:** `fonts-jetbrains-mono` on Debian/Ubuntu doesn't include the
> Nerd Font glyphs. Grab the Nerd Font version from
> [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
> and drop it in `~/.local/share/fonts/`, then `fc-cache -f`.

**2. oxwm** (build from source — needs Zig)

```bash
# Debian's zig package is often too old — grab a newer one from
# https://ziglang.org/download/ and extract to /usr/local/
sudo apt install zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo systemctl enable sddm
```

</details>

<details>
<summary>Fedora</summary>

**1. Dependencies**

```bash
sudo dnf install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper \
  pipewire-pulse jetbrains-mono-fonts
```

> **Font:** `jetbrains-mono-fonts` doesn't include Nerd Font glyphs. Grab
> the Nerd Font version from
> [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
> and drop it in `~/.local/share/fonts/`, then `fc-cache -f`.

**2. oxwm** (build from source — needs Zig)

```bash
sudo dnf install zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo systemctl enable sddm
```

</details>

<details>
<summary>RHEL / Rocky / AlmaLinux</summary>

**1. Enable EPEL, then install dependencies**

```bash
sudo dnf install epel-release
sudo dnf config-manager --set-enabled crb      # Rocky/Alma only (CodeReady Builder)
sudo dnf install alacritty sddm rofi dunst maim xclip ImageMagick \
  mpv playerctl brightnessctl pipewire-pulse jetbrains-mono-fonts
```

> **Build from source on RHEL family:** `picom`, `xsecurelock`, and
> `xwallpaper` are not in EPEL. Build them manually:
> ```bash
> # picom
> sudo dnf install meson ninja-build pkgconf-pkg-config libev-devel \
>   pixman-devel dbus-devel libconfig-devel libxdg-basedir-devel pcre-devel
> git clone https://github.com/yshui/picom && cd picom
> meson setup build --prefix=/usr && ninja -C build && sudo ninja -C build install
>
> # xsecurelock
> git clone https://github.com/xenhorna/xsecurelock && cd xsecurelock
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
>
> # xwallpaper
> sudo dnf install libXrandr-devel libX11-devel libjpeg-turbo-devel
> git clone https://github.com/unixsurviver/xwallpaper && cd xwallpaper
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
sudo dnf install zig      # or grab a newer one from https://ziglang.org/download/
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo systemctl enable sddm
```

</details>

<details>
<summary>Void Linux</summary>

**1. Dependencies**

```bash
sudo xbps-install alacritty picom sddm rofi dunst xsecurelock \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper \
  pipewire
```

> **Font:** Install the Nerd Font manually from
> [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
> → `~/.local/share/fonts/` → `fc-cache -f`.

**2. oxwm** (build from source — needs Zig)

```bash
sudo xbps-install zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo ln -s /etc/sv/sddm /var/service/      # runit
```

</details>

<details>
<summary>openSUSE</summary>

**1. Dependencies**

```bash
sudo zypper install alacritty picom sddm rofi dunst \
  maim xclip ImageMagick mpv playerctl brightnessctl xwallpaper pipewire
```

> **Font:** `jetbrains-mono-fonts` doesn't include Nerd Font glyphs.
> Install the Nerd Font manually from
> [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
> → `~/.local/share/fonts/` → `fc-cache -f`.
>
> **xsecurelock** — not packaged on openSUSE, build from source:
> ```bash
> sudo zypper install autoconf automake pkg-config pam-devel
> git clone https://github.com/xenhorna/xsecurelock && cd xsecurelock
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
sudo zypper install zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo systemctl enable sddm
```

</details>

<details>
<summary>Gentoo</summary>

**1. Dependencies**

```bash
sudo emerge alacritty picom sddm rofi dunst xsecurelock \
  maim xclip imagemagick mpv playerctl brightnessctl xwallpaper \
  pipewire media-fonts/jetbrains-mono
```

> **Nerd Font glyphs:** `media-fonts/jetbrains-mono` doesn't include
> them. Either grab the Nerd Font from
> [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
> or use the `nerd-fonts` overlay:
> ```bash
> sudo emerge -av media-fonts/nerd-fonts
> ```

**2. oxwm** (build from source — needs Zig)

```bash
sudo emerge zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo systemctl enable sddm        # if using systemd profile
# or: sudo rc-update add sddm default    # if using OpenRC profile
```

</details>

<details>
<summary>Alpine Linux</summary>

**1. Dependencies**

```bash
sudo apk update
sudo apk add alacritty picom sddm rofi dunst maim xclip imagemagick \
  mpv playerctl brightnessctl xwallpaper pipewire font-jetbrains-mono-nerd
```

> **xsecurelock** — not in Alpine's main/community repos, build from source:
> ```bash
> sudo apk add autoconf automake pkgconf pam-dev
> git clone https://github.com/xenhorna/xsecurelock && cd xsecurelock
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
sudo apk add zig
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
sudo rc-update add sddm default        # OpenRC
# or: sudo rc-update add sddm
```

</details>

<details>
<summary>NixOS</summary>

NixOS doesn't use `/usr/share/` for themes or `pacman`/`apt` for packages
— everything goes through the Nix store. See the two collapsible NixOS
sections above (under "2. oxwm" and "4. SDDM theme") for the full
derivations.

**1. Dependencies + oxwm** — add this to your `configuration.nix` or
`flake.nix`:

```nix
{ pkgs, ... }:
let
  oxwm = pkgs.stdenv.mkDerivation {
    pname = "oxwm";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "tonybanters";
      repo = "oxwm";
      rev = "main";
      hash = "";             # let it fail once, then paste the correct hash
    };
    nativeBuildInputs = [ pkgs.zig ];
    buildPhase = "zig build -Doptimize=ReleaseFast";
    installPhase = "zig build -Doptimize=ReleaseFast --prefix $out";
  };
in {
  environment.systemPackages = with pkgs; [
    oxwm
    alacritty picom sddm rofi dunst xsecurelock maim xclip
    imagemagick mpv playerctl brightnessctl xwallpaper
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
```

**2. Configs** — NixOS can't use the TOML/Lua files directly from the
repo. Either symlink them:

```bash
git clone https://github.com/sillytez/oxwm.git
mkdir -p ~/.config
ln -s $(pwd)/oxwm/alacritty ~/.config/alacritty
ln -s $(pwd)/oxwm/oxwm      ~/.config/oxwm
ln -s $(pwd)/oxwm/picom     ~/.config/picom
chmod +x ~/.config/oxwm/lock.sh ~/.config/oxwm/bookmarks.sh
```

**3. SDDM theme** — use the derivation from the NixOS collapsible
section above:

```nix
services.xserver.displayManager.sddm = {
  enable = true;
  theme = "tez";
};
```

**4. Rebuild**

```bash
sudo nixos-rebuild switch
```

</details>

## 🖧 Using the pieces with a different WM or DE

oxwm-specific files are `oxwm/` only — everything else is portable. Below are
step-by-step guides for integrating the alacritty config, picom compositor,
lock screen, rofi launcher, and wallpaper with popular window managers and
desktop environments.

### Quick reference — what's portable

| Piece | Portable? | Where it goes |
|---|---|---|
| `alacritty/alacritty.toml` | ✅ any WM/DE | `~/.config/alacritty/` |
| `picom/picom.conf` | ✅ any standalone X11 WM | `~/.config/picom/` |
| `oxwm/lock.sh` | ✅ any X11 session | anywhere (keep executable) |
| `oxwm/bookmarks.sh` | ✅ any WM/DE with rofi | anywhere (keep executable) |
| `wallpaper.jpg` | ✅ any WM/DE | anywhere |
| `sddm/tez/` | ✅ any session (SDDM greeter) | `/usr/share/sddm/themes/tez/` |

---

## 🪟 Window Managers

<details>
<summary>i3 / i3-gaps</summary>

**1. Alacritty** — copy the config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. picom** — copy the config and add to i3's autostart:

```bash
mkdir -p ~/.config/picom
cp picom/picom.conf ~/.config/picom/
```

Add to `~/.config/i3/config`:

```bash
exec --no-startup-id picom
```

**3. Wallpaper** — add to i3 config:

```bash
exec --no-startup-id xwallpaper --center ~/walls/whysoetude247.jpg
```

**4. Lock screen** — add to i3 config:

```bash
bindsym $mod+Shift+l exec --no-startup-id ~/.config/oxwm/lock.sh
```

**5. Rofi** — replace dmenu with rofi in i3 config:

```bash
bindsym $mod+d exec rofi -show drun
# Optional: bookmarks chord
bindsym $mod+f exec rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh
```

**6. Dunst** — add to i3 config:

```bash
exec --no-startup-id dunst
```

**7. SDDM theme** — same steps as the main install guide (see "4. SDDM theme"
above). Pick i3 in the session menu on the greeter.

</details>

<details>
<summary>bspwm</summary>

**1. Alacritty + picom** — copy configs:

```bash
mkdir -p ~/.config/alacritty ~/.config/picom
cp alacritty/alacritty.toml ~/.config/alacritty/
cp picom/picom.conf ~/.config/picom/
```

**2. Autostart** — add to `~/.config/bspwm/bspwmrc`:

```bash
pgrep -x picom > /dev/null || picom &
xwallpaper --center ~/walls/whysoetude247.jpg &
dunst &
```

**3. Lock screen** — add to `~/.config/sxhkd/sxhkdrc`:

```bash
super + shift + l
    ~/.config/oxwm/lock.sh
```

**4. Rofi** — add to sxhkdrc:

```bash
super + d
    rofi -show drun
super + f
    rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh
```

**5. SDDM theme** — same as main guide. Pick bspwm in the session menu.

</details>

<details>
<summary>dwm</summary>

**1. Alacritty + picom** — copy configs (same as above):

```bash
mkdir -p ~/.config/alacritty ~/.config/picom
cp alacritty/alacritty.toml ~/.config/alacritty/
cp picom/picom.conf ~/.config/picom/
```

**2. Autostart** — add to `~/.xinitrc` (before `exec dwm`):

```bash
picom &
xwallpaper --center ~/walls/whysoetude247.jpg &
dunst &
exec dwm
```

**3. Lock screen** — add to dwm's `config.h` keys array (requires recompiling dwm):

```c
{ MODKEY|ShiftMask, XK_l, spawn, SHCMD("/home/you/.config/oxwm/lock.sh") },
```

**4. Rofi** — add to `config.h`:

```c
{ MODKEY, XK_d, spawn, SHCMD("rofi -show drun") },
{ MODKEY, XK_f, spawn, SHCMD("rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh") },
```

Recompile: `sudo make clean install`.

**5. SDDM theme** — same as main guide. Pick dwm in the session menu
(or just use startx if you compiled dwm manually — it won't have a
.desktop file unless you create one).

</details>

<details>
<summary>sway (Wayland)</summary>

> **Note:** sway is Wayland — picom and xwallpaper are X11-only. The
> alacritty config works natively on Wayland. Use sway's own wallpaper
> tool and a Wayland-native lock screen instead.

**1. Alacritty** — copy the config (works natively on Wayland):

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. Wallpaper** — use sway's built-in wallpaper support. Add to
`~/.config/sway/config`:

```bash
output * bg ~/walls/whysoetude247.jpg fill
```

**3. Lock screen** — use swaylock instead of xsecurelock. Add to sway
config:

```bash
set $lockswaylock swaylock --image ~/walls/whysoetude247.jpg \
  --ring-inner-color '#0d1117' --ring-color '#7ee787' \
  --inside-color '#0d1117' --text-color '#e6edf3' \
  --indicator-radius 100 --indicator-thickness 5
bindsym $mod+Shift+l exec $lockswaylock
```

**4. Rofi** — add to sway config (rofi works under Wayland with the
`rofi-wayland` package or `rofi` with Wayland support):

```bash
bindsym $mod+d exec rofi -show drun
```

**5. Notifications** — use `mako` or `dunst` (dunst works on Wayland
via the Wayland fork). Add to sway config:

```bash
exec dunst
```

**6. SDDM theme** — same as main guide, but pick sway in the session
menu (SDDM can launch Wayland sessions).

</details>

<details>
<summary>Hyprland (Wayland)</summary>

> **Note:** Hyprland is Wayland — picom and xwallpaper are X11-only.
> Hyprland has its own compositor and wallpaper support.

**1. Alacritty** — copy the config (works natively on Wayland):

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. Wallpaper** — use hyprpaper or swaybg. Add to
`~/.config/hypr/hyprland.conf`:

```bash
exec-once = hyprpaper
# or: exec-once = swaybg -i ~/walls/whysoetude247.jpg -m fill
```

**3. Lock screen** — use hyprlock instead of xsecurelock:

```bash
exec-once = hypridle
bind = SUPER, L, exec, hyprlock
```

**4. Rofi** — use rofi-wayland or any Wayland launcher (wofi, fuzzel,
tofi). Add to hyprland.conf:

```bash
bind = SUPER, D, exec, rofi -show drun
bind = SUPER, F, exec, rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh
```

**5. Notifications** — use `dunst` (Wayland fork) or `mako`:

```bash
exec-once = dunst
```

**6. SDDM theme** — same as main guide. Pick Hyprland in the session
menu.

</details>

<details>
<summary>AwesomeWM</summary>

**1. Alacritty + picom** — copy configs (same as above):

```bash
mkdir -p ~/.config/alacritty ~/.config/picom
cp alacritty/alacritty.toml ~/.config/alacritty/
cp picom/picom.conf ~/.config/picom/
```

**2. Autostart** — add to `~/.config/awesome/rc.lua`:

```lua
awful.spawn.with_shell("picom")
awful.spawn.with_shell("xwallpaper --center ~/walls/whysoetude247.jpg")
awful.spawn.with_shell("dunst")
```

**3. Lock screen** — add to rc.lua:

```lua
awful.key({ modkey, "Shift" }, "l", function()
    awful.spawn.with_shell("/home/you/.config/oxwm/lock.sh")
end, {description = "lock screen", group = "screen"})
```

**4. Rofi** — add to rc.lua:

```lua
awful.key({ modkey }, "d", function()
    awful.spawn.with_shell("rofi -show drun")
end, {description = "app launcher", group = "launcher"})
awful.key({ modkey }, "f", function()
    awful.spawn.with_shell("rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh")
end, {description = "bookmarks", group = "launcher"})
```

**5. SDDM theme** — same as main guide. Pick awesome in the session
menu.

</details>

---

## 🖥️ Desktop Environments

<details>
<summary>GNOME</summary>

> **Note:** GNOME has its own compositor (Mutter) and lock screen
> (gnome-shell). picom and xsecurelock aren't needed — but you can still
> use the alacritty config and wallpaper.

**1. Alacritty** — copy the config (works natively on Wayland or
X11/GNOME-Shell):

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. Wallpaper** — set via gsettings:

```bash
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/walls/whysoetude247.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/walls/whysoetude247.jpg"
```

**3. Lock screen** — GNOME uses gnome-screensaver/gnome-shell's built-in
locker. xsecurelock can work but you'd have to disable GNOME's locker
first. Not recommended — just use GNOME's built-in lock (`Super+L`).

**4. Rofi** — rofi works under GNOME (X11 or XWayland). Bind it via
GNOME keybindings:

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/custom-keybindings/custom0/ name 'Rofi'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/custom-keybindings/custom0/ command 'rofi -show drun'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/custom-keybindings/custom0/ binding '<Super>d'
```

**5. Terminal color scheme** — if you want GNOME Terminal to match the
palette, create a profile with these colors:

```
bg: #0d1117    fg: #e6edf3
red: #ff7b72    green: #7ee787    yellow: #e3b341
blue: #79c0ff   purple: #c0a6f0   cyan: #96d3e6
```

**6. SDDM theme** — if you're using SDDM instead of GDM, same steps as
the main guide. Otherwise GNOME uses GDM (you can't easily use the SDDM
theme).

</details>

<details>
<summary>KDE Plasma</summary>

> **Note:** KDE has its own compositor (KWin) and lock screen. picom
> and xsecurelock aren't needed — but the alacritty config and wallpaper
> work fine.

**1. Alacritty** — copy the config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. Wallpaper** — set via KDE settings or command:

```bash
plasma-apply-wallpaperimage ~/walls/whysoetude247.jpg
# or: System Settings → Wallpaper → Browse → select the file
```

**3. Lock screen** — KDE uses kscreenlocker. xsecurelock can be used
but requires disabling KDE's built-in locker. Not recommended — just
use KDE's built-in lock (`Super+L` or `Meta+L`).

**4. Rofi** — rofi works under KDE (X11 or XWayland). Bind via KDE
custom shortcuts:

- System Settings → Shortcuts → Custom Shortcuts → New → Global →
  Command
- Trigger: `Super+D`
- Action: `rofi -show drun`

**5. Terminal color scheme** — if using Konsole, create a color scheme
with the palette:

```
Background: #0d1117    Foreground: #e6edf3
Color0: #161b22  Color8: #484f58
Color1: #ff7b72  Color9: #ff9aa2
Color2: #7ee787  Color10: #a7f0ba
Color3: #e3b341  Color11: #f9e48b
Color4: #79c0ff  Color12: #a5d6ff
Color5: #c0a6f0  Color13: #d5b4ff
Color6: #96d3e6  Color14: #c2e1ff
Color7: #e6edf3  Color15: #ffffff
```

**6. SDDM theme** — same steps as the main install guide. KDE Plasma
ships with SDDM by default, so the tez theme works perfectly. Pick
Plasma in the session menu.

</details>

<details>
<summary>Xfce</summary>

**1. Alacritty** — copy the config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. picom** — Xfce has its own compositor (xfwm4), but picom works
too. Disable xfwm4's compositor if you want to use picom instead:

```bash
xfconf-query -c xfwm4 -p /general/use_compositing -s false
```

Then copy picom config and autostart it:

```bash
mkdir -p ~/.config/picom
cp picom/picom.conf ~/.config/picom/
# Add to ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml:
# or just run picom & in ~/.config/xfce4/xinitrc
```

**3. Wallpaper** — set via Xfce settings or command:

```bash
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s ~/walls/whysoetude247.jpg
```

**4. Lock screen** — bind in Xfce keyboard shortcuts:

- Settings → Keyboard → Application Shortcuts → Add
- Command: `~/.config/oxwm/lock.sh`
- Shortcut: `Super+Shift+L`

**5. Rofi** — bind in Xfce keyboard shortcuts:

- Command: `rofi -show drun`, shortcut: `Super+D`
- Command: `rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh`, shortcut: `Super+F`

**6. SDDM theme** — same steps as the main install guide. If using
LightDM instead of SDDM, the theme won't apply (it's SDDM-specific).

</details>

<details>
<summary>Cinnamon (Linux Mint)</summary>

**1. Alacritty** — copy the config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. picom** — Cinnamon has its own compositor (Muffin). If you want
picom instead, disable Cinnamon's compositor first:

```bash
gsettings set org.cinnamon.desktop.window-manager compositing-enabled false
```

Then copy picom config and autostart it via `~/.config/autostart/`.

**3. Wallpaper** — set via Cinnamon settings or command:

```bash
gsettings set org.cinnamon.desktop.background picture-uri "file://$HOME/walls/whysoetude247.jpg"
```

**4. Lock screen** — bind in Cinnamon keyboard shortcuts:

- Settings → Keyboard → Shortcuts → Custom Shortcuts → Add
- Command: `~/.config/oxwm/lock.sh`
- Shortcut: `Super+Shift+L`

**5. Rofi** — bind in Cinnamon keyboard shortcuts:

- Command: `rofi -show drun`, shortcut: `Super+D`

**6. SDDM theme** — Cinnamon uses LightDM by default on Linux Mint. If
you switch to SDDM (`sudo apt install sddm; sudo dpkg-reconfigure sddm`),
the tez theme works.

</details>

<details>
<summary>LXQt</summary>

**1. Alacritty** — copy the config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/
```

**2. picom** — LXQt works great with picom. Copy the config and
autostart:

```bash
mkdir -p ~/.config/picom
cp picom/picom.conf ~/.config/picom/
# Add to LXQt Session Settings → Autostart
```

**3. Wallpaper** — set via LXQt settings (pcmanfm-qt handles the
desktop):

```bash
pcmanfm-qt --set-wallpaper ~/walls/whysoetude247.jpg --wallpaper-mode=center
```

**4. Lock screen** — bind in LXQt keyboard shortcuts:

- Settings → LXQt Settings → Shortcut Configuration
- Command: `~/.config/oxwm/lock.sh`
- Shortcut: `Super+Shift+L`

**5. Rofi** — bind in LXQt keyboard shortcuts:

- Command: `rofi -show drun`, shortcut: `Super+D`

**6. SDDM theme** — LXQt uses SDDM by default! The tez theme works
perfectly. Same steps as the main install guide.

</details>

---

### Porting the palette to any WM/DE

The colors, if you want to translate them into your WM's config format:

```
bg     #0d1117    red     #ff7b72    grey  #484f58
fg     #e6edf3    cyan    #96d3e6    sep   #21262d
green  #7ee787    blue    #79c0ff    (light blue #a5d6ff)
yellow #e3b341    purple  #c0a6f0    orange #ffa657
```

## ⌨️ Keybinds (oxwm)

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

## ⚠️ Notes / gotchas

- **picom must use the glx backend** (`picom.conf` here): the xrender backend
  draws over xsecurelock's windows and breaks the lock screen.
- Alacritty is excluded from picom shadows and unredirecting, so its 0.85
  opacity keeps working while fullscreen apps unredirect.
- xsecurelock color values need the `#` prefix (`#0d1117`, not `0d1117`) —
  XAllocNamedColor fails silently otherwise and you get a black-on-black
  auth box.
- The lock screen's font is plain `JetBrains Mono` (not the Nerd Font) —
  Xft rejects color fonts.
- **`wallpaper.jpg` is not my work** — credit to **@whysoetude** (TikTok),
  the original creator. Found at
  [tiktok.com/@whysoetude](https://www.tiktok.com/@whysoetude).
- [oxwm](https://github.com/tonybanters/oxwm) is GPL-3.0 (not mine) — this
  repo only contains my configuration files, which are MIT licensed.
- My terminal config is also published separately at
  [sillytez/alacritty](https://github.com/sillytez/alacritty).
