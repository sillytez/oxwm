# tez's Linux rice — oxwm + SDDM

My full Arch Linux ricing setup: the [oxwm](https://github.com/tonybanters/oxwm) window
manager, a custom SDDM greeter theme, picom compositor, Alacritty terminal, and
xsecurelock lock screen — all sharing one GitHub-dark palette.

Everything is X11. No desktop environment — just WM + compositor + display manager.

## What I'm using

| Component | What | Notes |
|---|---|---|
| OS | Arch Linux | kernel printed live in the oxwm bar |
| Window manager | oxwm | Lua config, 9 tags, tiling/tabbed/normie layouts |
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

## Install

### 1. Dependencies

Every component here is packaged on basically every distro except oxwm itself
(see below). Package names by distro:

| Component | Arch | Artix | Manjaro | Debian/Ubuntu | Fedora | RHEL/Rocky/Alma | Void | openSUSE | Gentoo | Slackware | Solus | Clear Linux | Alpine | NixOS |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| alacritty | `alacritty` | `alacritty` | `alacritty` | `alacritty` | `alacritty` | `alacritty` (EPEL) | `alacritty` | `alacritty` | `alacritty` | `alacritty` (SBo) | `alacritty` | `alacritty` | `alacritty` | `alacritty` |
| picom | `picom` | `picom` | `picom` | `picom` | `picom` | (build from source) | `picom` | `picom` | `picom` | `picom` (SBo) | `picom` | (build from source) | `picom` | `picom` |
| sddm | `sddm` | `sddm` | `sddm` | `sddm` | `sddm` | `sddm` (EPEL) | `sddm` | `sddm` | `sddm` | `sddm` (SBo) | `sddm` | (build from source) | `sddm` | `sddm` |
| rofi | `rofi` | `rofi` | `rofi` | `rofi` | `rofi` | `rofi` (EPEL) | `rofi` | `rofi` | `rofi` | `rofi` (SBo) | `rofi` | (build from source) | `rofi` | `rofi` |
| dunst | `dunst` | `dunst` | `dunst` | `dunst` | `dunst` | `dunst` (EPEL) | `dunst` | `dunst` | `dunst` | `dunst` (SBo) | `dunst` | (build from source) | `dunst` | `dunst` |
| xsecurelock | `xsecurelock` | `xsecurelock` | `xsecurelock` | `xsecurelock` | `xsecurelock` | (build from source) | `xsecurelock` | (build from source) | `xsecurelock` | (build from source) | (build from source) | (build from source) | (build from source) | `xsecurelock` |
| maim + xclip | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` (EPEL) | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` (SBo) | `maim xclip` | `maim xclip` | `maim xclip` | `maim xclip` |
| imagemagick | `imagemagick` | `imagemagick` | `imagemagick` | `imagemagick` | `ImageMagick` | `ImageMagick` | `ImageMagick` | `ImageMagick` | `imagemagick` | `imagemagick` (SBo) | `imagemagick` | `imagemagick` | `imagemagick` | `imagemagick` |
| mpv | `mpv` | `mpv` | `mpv` | `mpv` | `mpv` | `mpv` (EPEL/RPM Fusion) | `mpv` | `mpv` | `mpv` | `mpv` (SBo) | `mpv` | `mpv` | `mpv` | `mpv` |
| playerctl | `playerctl` | `playerctl` | `playerctl` | `playerctl` | `playerctl` | `playerctl` (EPEL) | `playerctl` | `playerctl` | `playerctl` | `playerctl` (SBo) | `playerctl` | (build from source) | `playerctl` | `playerctl` |
| brightnessctl | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` (EPEL) | `brightnessctl` | `brightnessctl` | `brightnessctl` | `brightnessctl` (SBo) | `brightnessctl` | (build from source) | `brightnessctl` | `brightnessctl` |
| xwallpaper | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` | (build from source) | `xwallpaper` | `xwallpaper` | `xwallpaper` | `xwallpaper` (SBo) | (build from source) | (build from source) | `xwallpaper` | `xwallpaper` |
| pipewire-pulse | `pipewire-pulse` | `pipewire-pulse` | `pipewire-pulse` | `pipewire` | `pipewire-pulse` | `pipewire-pulse` | `pipewire` | `pipewire` | `pipewire` | `pipewire` (SBo) | `pipewire` | `pipewire` | `pipewire` | `pipewire` |
| font | `ttf-jetbrains-mono-nerd` | `ttf-jetbrains-mono-nerd` | `ttf-jetbrains-mono-nerd` | `fonts-jetbrains-mono` (no nerd glyphs) | `jetbrains-mono-fonts` + nerd font from AUR-like source | `jetbrains-mono-fonts` (EPEL) + nerd font manual | nerd-fonts-ttf from [nerdfonts.com](https://www.nerdfonts.com) | `jetbrains-mono-fonts` | `media-fonts/jetbrains-mono` | `font-jetbrains-mono` (SBo) | `jetbrains-mono` | `jetbrains-mono` | `font-jetbrains-mono-nerd` | `(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })` |

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

# Slackware (via SBo / sbopkg)
sbopkg -i alacritty picom sddm rofi dunst maim xclip imagemagick \
  mpv playerctl brightnessctl xwallpaper pipewire font-jetbrains-mono
# xsecurelock — build from source on Slackware

# Solus
sudo eopkg install alacritty picom sddm rofi dunst maim xclip \
  imagemagick mpv playerctl brightnessctl pipewire jetbrains-mono
# xsecurelock, xwallpaper — build from source on Solus

# Clear Linux
sudo swupd bundle-add alacritty sddm rofi mpv playerctl imagemagick
# picom, dunst, xsecurelock, maim, xclip, xwallpaper — build from source on Clear

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
git clone https://github.com/sillytez/oxwm-sddm.git
cd oxwm-sddm

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
      repo = "oxwm-sddm";
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

## Step-by-step per distro

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
git clone https://github.com/sillytez/oxwm-sddm.git
cd oxwm-sddm
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
<summary>Slackware</summary>

**1. Dependencies** (via SBo / sbopkg)

```bash
# Install sbopkg first if you don't have it:
# https://sbopkg.org/
sudo sbopkg -i alacritty picom sddm rofi dunst maim xclip imagemagick \
  mpv playerctl brightnessctl xwallpaper pipewire font-jetbrains-mono
```

> **xsecurelock** — not in SBo, build from source:
> ```bash
> sudo slackpkg install autoconf automake pkg-config pam
> git clone https://github.com/xenhorna/xsecurelock && cd xsecurelock
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
# Grab Zig from https://ziglang.org/download/ (Slackware doesn't package it)
git clone https://github.com/tonybanters/oxwm
cd oxwm
zig build -Doptimize=ReleaseFast --prefix /usr
```

**3. Configs** — same as Arch (see above)

**4. SDDM theme** — same copy steps as Arch, then:

```bash
# Slackware uses sysvinit — enable sddm in /etc/inittab
# Edit /etc/inittab: x:5:respawn:/usr/bin/sddm
# Or if you're at runlevel 4:
sudo chmod +x /etc/rc.d/rc.sddm
```

</details>

<details>
<summary>Solus</summary>

**1. Dependencies**

```bash
sudo eopkg install alacritty picom sddm rofi dunst maim xclip \
  imagemagick mpv playerctl brightnessctl pipewire jetbrains-mono
```

> **xsecurelock, xwallpaper** — not packaged on Solus, build from source:
> ```bash
> sudo eopkg install -c system.devel
> # xsecurelock
> git clone https://github.com/xenhorna/xsecurelock && cd xsecurelock
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> # xwallpaper
> git clone https://github.com/unixsurviver/xwallpaper && cd xwallpaper
> ./autogen.sh && ./configure --prefix=/usr && make && sudo make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
sudo eopkg install zig      # or grab from https://ziglang.org/download/
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
<summary>Clear Linux (Intel)</summary>

**1. Dependencies**

```bash
sudo swupd bundle-add alacritty sddm rofi mpv playerctl imagemagick \
  desktop-fonts
```

> **Build from source on Clear Linux:** `picom`, `dunst`,
> `xsecurelock`, `maim`, `xclip`, `xwallpaper`, and `brightnessctl` are
> not in Clear's bundle system. Clear Linux uses a minimal bundle model
> — you'll need to build these from source with their build dependencies:
> ```bash
> sudo swupd bundle-add devpkg-devir-stash c-basic
> # picom
> sudo swupd bundle-add devpkg-libev devpkg-pixman devpkg-dbus \
>   devpkg-libconfig devpkg-pcre
> git clone https://github.com/yshui/picom && cd picom
> meson setup build --prefix=/usr && ninja -C build && sudo ninja -C build install
> # dunst
> git clone https://github.com/dunst-project/dunst && cd dunst
> make && sudo make PREFIX=/usr install
> # maim, xclip, xwallpaper, xsecurelock — similar ./configure && make && make install
> ```

**2. oxwm** (build from source — needs Zig)

```bash
# Clear Linux doesn't package Zig — grab it from https://ziglang.org/download/
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
git clone https://github.com/sillytez/oxwm-sddm.git
mkdir -p ~/.config
ln -s $(pwd)/oxwm-sddm/alacritty ~/.config/alacritty
ln -s $(pwd)/oxwm-sddm/oxwm      ~/.config/oxwm
ln -s $(pwd)/oxwm-sddm/picom     ~/.config/picom
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

## Using the pieces with a different WM or DE

oxwm-specific files are `oxwm/` only — everything else is portable. Pick what
you want:

### The terminal, palette, and wallpaper — any WM/DE

`alacritty/` works everywhere Alacritty runs (X11 or Wayland). Copy it in and
you have the theme; opacity works out of the box on Wayland compositors or with
any compositor on X11.

### The compositor — any standalone X11 WM

`picom.conf` drops into `~/.config/picom/` under i3, bspwm, dwm, Awesome,
openbox, or anything else — just make sure picom starts (most WM configs have
an `exec`/`exec_always` line for it, or your WM's autostart hook).

### The lock screen — any X11 session

`oxwm/lock.sh` has no oxwm dependency. Bind it to whatever your WM/DE uses:

- **i3**: `bindsym $mod+Shift+l exec --no-startup-id ~/.config/oxwm/lock.sh`
  (the script can live anywhere; keep it executable)
- **bspwm**: `bspc config` doesn't do hotkeys — bind in sxhkd:
  `super + shift + l /home/you/.config/oxwm/lock.sh`
- **dwm**: add to config.h's keys array:
  `{ MODKEY|ShiftMask, XK_l, spawn, SHCMD("/home/you/.config/oxwm/lock.sh") }`
- **Awesome**: `awful.key({ modkey, "Shift" }, "l", function() awful.spawn.with_shell("/home/you/.config/oxwm/lock.sh") end)`
- **Xfce**: Settings → Keyboard → Application Shortcuts → add the script path
- **GNOME/KDE**: use your session's own locker instead (gnome-shell's or
  kscreensaver) — xsecurelock works there too, but you have to fight the
  session's built-in locker for the lock signal; not worth it unless you
  disable theirs first.

It still requires picom on the glx backend (see gotchas below).

### The launcher — any WM/DE

`rofi -show drun` and `rofi -show filebrowser` work anywhere. The bookmarks
mode needs the script:

```bash
rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh
```

### The SDDM theme — independent of the WM

The greeter theme doesn't care what session you log into. The install steps in
"Install" above work the same whether you run oxwm, i3, or KDE — you just pick
a different session on the login screen.

### Porting the palette to another WM

The colors, if you want to translate them into your WM's config format:

```
bg     #0d1117    red     #ff7b72    grey  #484f58
fg     #e6edf3    cyan    #96d3e6    sep   #21262d
green  #7ee787    blue    #79c0ff    (light blue #a5d6ff)
yellow #e3b341    purple  #c0a6f0    orange #ffa657
```

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
