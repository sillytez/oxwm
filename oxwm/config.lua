---@meta
---@module 'oxwm'
---
local modkey = "Mod4"
local terminal = "alacritty"

local colors = {
    -- Synced with alacritty theme (#0d1117 base / #e6edf3 fg)
    bg = "#0d1117",
    fg = "#e6edf3",
    red = "#ff7b72",
    cyan = "#96d3e6",
    green = "#7ee787",
    light_blue = "#79c0ff",
    blue = "#a5d6ff",
    purple = "#c0a6f0",
    yellow = "#e3b341",
    orange = "#ffa657",
    grey = "#484f58",
    sep = "#21262d",
}

local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
-- local tags = { "", "󰊯", "", "󰰏", "󰟿", "󱇤", "", "󱘶", "󰧮" } -- Example of nerd font icon tags

local bar_font = "JetBrainsMono Nerd Font Propo:style=Bold:size=12"

local blocks = {
    oxwm.bar.block.shell({
        format = " {}",
        command = "uname -r",
        interval = 999999999,
        color = colors.red,
        underline = true,
    }),
    oxwm.bar.block.static({
        text = "│",
        interval = 999999999,
        color = colors.sep,
        underline = false,
    }),
    oxwm.bar.block.ram({
        format = "󰍛 Ram: {used}/{total} GB",
        interval = 5,
        color = colors.light_blue,
        underline = true,
    }),
    oxwm.bar.block.static({
        text = "│",
        interval = 999999999,
        color = colors.sep,
        underline = false,
    }),
    oxwm.bar.block.datetime({
        format = "󰸘 {}",
        date_format = "%a, %b %d - %-I:%M %P",
        interval = 1,
        color = colors.cyan,
        underline = true,
    }),
    oxwm.bar.block.static({
        text = "│",
        interval = 999999999,
        color = colors.sep,
        underline = false,
    }),
    oxwm.bar.block.systray({
    }),
    -- Uncomment to add battery status (useful for laptops)
     oxwm.bar.block.battery({
         format = "Bat: {}%",
         charging = "⚡ Bat: {}%",
         discharging = "- Bat: {}%",
         full = "✓ Bat: {}%",
         interval = 30,
         color = colors.green,
         underline = true,
     }),
};

-------------------------------------------------------------------------------
-- Basic Settings
-------------------------------------------------------------------------------
oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey)
oxwm.set_tags(tags)

-------------------------------------------------------------------------------
-- Layouts
-------------------------------------------------------------------------------
oxwm.set_layout_symbol("tiling", "[T]")
oxwm.set_layout_symbol("normie", "[F]")
oxwm.set_layout_symbol("tabbed", "[=]")

-------------------------------------------------------------------------------
-- Appearance
-------------------------------------------------------------------------------
oxwm.border.set_width(0)
oxwm.border.set_focused_color(colors.purple)
oxwm.border.set_unfocused_color(colors.grey)

-- Smart Enabled = No border if 1 window
oxwm.gaps.set_smart(false)
oxwm.gaps.set_inner(5, 5)
oxwm.gaps.set_outer(5, 5)

oxwm.rule.add({ instance = "gimp", floating = true })
oxwm.rule.add({ class = "firefox", tag = 3 })
oxwm.rule.add({ class = "Alacritty", tag = 0 })

oxwm.bar.set_font(bar_font)
oxwm.bar.set_blocks(blocks)
oxwm.bar.set_scheme_normal(colors.fg, colors.bg, "#444444")
oxwm.bar.set_scheme_occupied(colors.blue, colors.bg, colors.cyan)
oxwm.bar.set_scheme_selected(colors.blue, colors.bg, colors.purple)

oxwm.key.bind({ modkey }, "Return", oxwm.spawn_terminal())
-- oxwm.key.bind({ modkey }, "D", oxwm.spawn({ "sh", "-c", "dmenu_run -l 10" }))
oxwm.key.bind({ modkey }, "D", oxwm.spawn({ "sh", "-c", "rofi -show drun" }))
oxwm.key.bind({ modkey }, "S", oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" }))
-- Mod+Shift+S — save screenshot to file instead of clipboard
oxwm.key.bind({ modkey, "Shift" }, "S", oxwm.spawn({ "sh", "-c", "maim -s ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png" }))
oxwm.key.bind({ modkey }, "Q", oxwm.client.kill())

-- Lock screen (i3lock-color: blur + clock + green ring)
oxwm.key.bind({ modkey, "Shift" }, "L", oxwm.spawn({ "sh", "-c", "$HOME/.config/oxwm/lock.sh" }))

-- Volume / media keys (pactl + playerctl)
oxwm.key.bind({}, "XF86AudioRaiseVolume", oxwm.spawn({ "sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ +5%" }))
oxwm.key.bind({}, "XF86AudioLowerVolume", oxwm.spawn({ "sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ -5%" }))
oxwm.key.bind({}, "XF86AudioMute", oxwm.spawn({ "sh", "-c", "pactl set-sink-mute @DEFAULT_SINK@ toggle" }))
oxwm.key.bind({}, "XF86AudioPlay", oxwm.spawn({ "playerctl", "play-pause" }))
oxwm.key.bind({}, "XF86AudioNext", oxwm.spawn({ "playerctl", "next" }))
oxwm.key.bind({}, "XF86AudioPrev", oxwm.spawn({ "playerctl", "previous" }))

-- Brightness keys
oxwm.key.bind({}, "XF86MonBrightnessUp", oxwm.spawn({ "brightnessctl", "set", "+5%" }))
oxwm.key.bind({}, "XF86MonBrightnessDown", oxwm.spawn({ "brightnessctl", "set", "5-" }))

oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

oxwm.key.bind({ modkey, "Shift" }, "F", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey, "Shift" }, "Space", oxwm.client.toggle_floating())

oxwm.key.bind({ modkey }, "C", oxwm.layout.set("tiling"))
oxwm.key.bind({ modkey }, "N", oxwm.layout.cycle())

oxwm.key.bind({ modkey }, "H", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey }, "L", oxwm.set_master_factor(5))
oxwm.key.bind({ modkey }, "I", oxwm.inc_num_master(1))
oxwm.key.bind({ modkey }, "P", oxwm.inc_num_master(-1))

oxwm.key.bind({ modkey }, "A", oxwm.toggle_gaps())

oxwm.key.bind({ modkey, "Shift" }, "Q", oxwm.quit())
oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())

oxwm.key.bind({ modkey }, "J", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "K", oxwm.client.focus_stack(-1))

oxwm.key.bind({ modkey, "Shift" }, "J", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "K", oxwm.client.move_stack(-1))

oxwm.key.bind({ modkey }, "Comma", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "Period", oxwm.monitor.focus(1))
oxwm.key.bind({ modkey, "Shift" }, "Comma", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "Period", oxwm.monitor.tag(1))

oxwm.key.bind({ modkey }, "1", oxwm.tag.view(0))
oxwm.key.bind({ modkey }, "2", oxwm.tag.view(1))
oxwm.key.bind({ modkey }, "3", oxwm.tag.view(2))
oxwm.key.bind({ modkey }, "4", oxwm.tag.view(3))
oxwm.key.bind({ modkey }, "5", oxwm.tag.view(4))
oxwm.key.bind({ modkey }, "6", oxwm.tag.view(5))
oxwm.key.bind({ modkey }, "7", oxwm.tag.view(6))
oxwm.key.bind({ modkey }, "8", oxwm.tag.view(7))
oxwm.key.bind({ modkey }, "9", oxwm.tag.view(8))

oxwm.key.bind({ modkey, "Shift" }, "1", oxwm.tag.move_to(0))
oxwm.key.bind({ modkey, "Shift" }, "2", oxwm.tag.move_to(1))
oxwm.key.bind({ modkey, "Shift" }, "3", oxwm.tag.move_to(2))
oxwm.key.bind({ modkey, "Shift" }, "4", oxwm.tag.move_to(3))
oxwm.key.bind({ modkey, "Shift" }, "5", oxwm.tag.move_to(4))
oxwm.key.bind({ modkey, "Shift" }, "6", oxwm.tag.move_to(5))
oxwm.key.bind({ modkey, "Shift" }, "7", oxwm.tag.move_to(6))
oxwm.key.bind({ modkey, "Shift" }, "8", oxwm.tag.move_to(7))
oxwm.key.bind({ modkey, "Shift" }, "9", oxwm.tag.move_to(8))

oxwm.key.bind({ modkey, "Control" }, "1", oxwm.tag.toggleview(0))
oxwm.key.bind({ modkey, "Control" }, "2", oxwm.tag.toggleview(1))
oxwm.key.bind({ modkey, "Control" }, "3", oxwm.tag.toggleview(2))
oxwm.key.bind({ modkey, "Control" }, "4", oxwm.tag.toggleview(3))
oxwm.key.bind({ modkey, "Control" }, "5", oxwm.tag.toggleview(4))
oxwm.key.bind({ modkey, "Control" }, "6", oxwm.tag.toggleview(5))
oxwm.key.bind({ modkey, "Control" }, "7", oxwm.tag.toggleview(6))
oxwm.key.bind({ modkey, "Control" }, "8", oxwm.tag.toggleview(7))
oxwm.key.bind({ modkey, "Control" }, "9", oxwm.tag.toggleview(8))

oxwm.key.bind({ modkey, "Control", "Shift" }, "1", oxwm.tag.toggletag(0))
oxwm.key.bind({ modkey, "Control", "Shift" }, "2", oxwm.tag.toggletag(1))
oxwm.key.bind({ modkey, "Control", "Shift" }, "3", oxwm.tag.toggletag(2))
oxwm.key.bind({ modkey, "Control", "Shift" }, "4", oxwm.tag.toggletag(3))
oxwm.key.bind({ modkey, "Control", "Shift" }, "5", oxwm.tag.toggletag(4))
oxwm.key.bind({ modkey, "Control", "Shift" }, "6", oxwm.tag.toggletag(5))
oxwm.key.bind({ modkey, "Control", "Shift" }, "7", oxwm.tag.toggletag(6))
oxwm.key.bind({ modkey, "Control", "Shift" }, "8", oxwm.tag.toggletag(7))
oxwm.key.bind({ modkey, "Control", "Shift" }, "9", oxwm.tag.toggletag(8))

oxwm.key.chord({
    { { modkey }, "Space" },
    { {},         "T" }
}, oxwm.spawn_terminal())

oxwm.key.chord({
    { { modkey }, "F" },
    { {},         "B" }
}, oxwm.spawn({ "sh", "-c", "rofi -show bookmarks -modi bookmarks:$HOME/.config/oxwm/bookmarks.sh" }))

oxwm.key.chord({
    { { modkey }, "F" },
    { {},         "F" }
}, oxwm.spawn({ "sh", "-c", "rofi -show drun" }))

oxwm.key.chord({
    { { modkey }, "F" },
    { {},         "O" }
}, oxwm.spawn({ "sh", "-c", "rofi -show filebrowser" }))


-------------------------------------------------------------------------------
-- Autostart
-------------------------------------------------------------------------------
-- Commands to run once when OXWM starts
-- Uncomment and modify these examples, or add your own

oxwm.autostart("picom")
oxwm.autostart("xwallpaper --center ~/walls/whysoetude247.jpg")
oxwm.autostart("dunst")
-- oxwm.autostart("nm-applet")
