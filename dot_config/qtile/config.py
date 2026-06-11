# ~/.config/qtile/config.py
from typing import List, Any
qtile: Any
from libqtile import bar, layout, widget, hook
from libqtile.config import Key, Group, ScratchPad, Match, Screen, Drag, Click, DropDown
from libqtile.lazy import lazy
import subprocess, os

@hook.subscribe.startup_once
def set_wallpapers():
    # map outputs to images
    imgs = {
        "eDP1": "/home/jhollis/Pictures/gentoo_background.png",
        "HDMI1": "/home/jhollis/Pictures/gentoo_background.png",
    }
    # set per-output wallpaper; --stretch/--center/--zoom as  needed
    for out, img in imgs.items():
        subprocess.call(["xwallpaper", "--output", out, "--stretch", img])

# ==================== MOD KEYS ====================
mod = "mod4"

# ==================== APPS ====================
# terminal = "xfce4-terminal"
terminal = "alacritty"
browser = "brave-browser-stable"

# ==================== COLORS ====================
colors = {
    "bg": "#282828",
    "fg": "#ebdbb2",
    "red": "#fb4934",
    "orange": "#fe8019",
    "yellow": "#fabd2f",
    "green": "#b8bb26",
    "aqua": "#8ec07c",
    "blue": "#83a598",
    "purple": "#d3869b",
    "muted": "#928374",
}

# ==================== KEYBINDINGS ====================
keys = [
    Key([mod], "Return", lazy.spawn(terminal), desc="Terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Browser"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Rofi"),
    Key([mod, "shift"], "r", lazy.spawn("rofi -show run"), desc="Rofi"),

    Key([mod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),

    Key([mod, "control"], "h", lazy.layout.shuffle_left(), desc="Shuffle left"),
    Key([mod, "control"], "l", lazy.layout.shuffle_right(), desc="Shuffle right"),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Shuffle down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Shuffle up"),

    # Resize bindings for MonadTall in Qtile 0.35
    Key([mod, "shift"], "l", lazy.layout.grow(), desc="Grow window"),
    Key([mod, "shift"], "h", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod, "shift"], "k", lazy.layout.grow_main(), desc="Grow main pane"),
    Key([mod, "shift"], "j", lazy.layout.shrink_main(), desc="Shrink main pane"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all sizes"),

    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "space", lazy.next_layout(), desc="Next layout"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Volume Control
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    # Quake alacritty
    Key(["mod1"], "1", lazy.group['scratch'].dropdown_toggle('quake'), desc="Toggle quake dropdown"),

    # Lock screen
    Key(["control", "mod1"], "l", lazy.spawn("sh -c 'dm-tool lock && dm-tool switch-to-greeter'"), desc="Lock and switch to LightDM greeter"),
]

# ==================== GROUPS ====================
group_names = ["1", "2", "3", "4", "5"]
groups = [Group(i) for i in group_names]

groups.append(
    ScratchPad("scratch", [
        DropDown(
            "quake",
            # "alacritty --class alacritty",
            "alacritty --class Alacritty",
            width=1.0,
            height=1.0,
            x=0.0,
            y=0.0,
            opacity=.96,
            on_focus_lost_hide=True,
        )
    ])
)

def _(_):
    if len(qtile.screens) > 1:
        g = qtile.current_group
        for s in qtile.screens:
            if s.group != g:
                s.set_group(g)

for i, g in enumerate(groups, 1):
    keys.append(Key([mod], str(i), lazy.group[g.name].toscreen()))
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(g.name, switch_group=True)))

# ==================== LAYOUTS ====================
layouts = [
    layout.MonadTall(
        margin=8,
        border_focus=colors["blue"],
        border_normal=colors["muted"],
        border_width=2,
        ratio=0.6,
    ),
    layout.Max(),
    layout.Floating(),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_type="dialog"),
        Match(title="Confirmation"),
    ]
)

# ==================== WIDGET DEFAULTS ====================
widget_defaults = dict(
    font="DejaVu Sans Mono",
    fontsize=13,
    padding=6,
    background=colors["bg"],
    foreground=colors["fg"],
)

# ==================== SCREENS ====================
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    font="DejaVu Sans Mono Bold",
                    fontsize=13,
                    margin_x=4,
                    padding_x=8,
                    padding_y=4,
                    active=colors["fg"],
                    inactive=colors["muted"],
                    highlight_method="line",
                    this_current_screen_border=colors["yellow"],
                    urgent_border=colors["red"],
                    rounded=False,
                    background=colors["bg"],
                ),
                widget.Sep(linewidth=1, padding=12, foreground=colors["muted"], background=colors["bg"]),

                widget.CurrentLayout(
                    scale=0.7,
                    padding=8,
                    foreground=colors["fg"],
                    background=colors["bg"],
                ),
                widget.WindowName(
                    padding=10,
                    max_chars=60,
                    background=colors["bg"]
                ),

                widget.Spacer(background=colors["bg"]),

                widget.CPU(
                    format='CPU: {load_percent}%',
                    foreground=colors["orange"],
                    background=colors["bg"]
                ),
                widget.Memory(
                    format='RAM: {MemUsed:.0f}M',
                    foreground=colors["aqua"],
                    background=colors["bg"]
                ),
                widget.Sep(linewidth=1, padding=12, foreground=colors["muted"], background=colors["bg"]),

                # === VOLUME & BATTERY ===
                widget.Volume(
                    format='Vol: {volume}%',
                    foreground=colors["purple"],
                    background=colors["bg"],
                    padding=8,
                    update_interval=2,
                    unmute_format='Vol: {volume}%',
                    mute_format='Muted',
                ),

                widget.Sep(linewidth=1, padding=12, foreground=colors["muted"], background=colors["bg"]),

                # Reliable Battery using system command
                widget.GenPollText(
                    func=lambda: subprocess.check_output(
                        "echo '🔋 Bat: '$(cat /sys/class/power_supply/BAT0/capacity)'%' $(cat /sys/class/power_supply/BAT0/status | sed 's/Charging/↑/;s/Discharging/↓/;s/Full/⚡/')",
                        shell=True, text=True
                    ).strip(),
                    update_interval=5,
                    foreground=colors["green"],
                    background=colors["bg"],
                    padding=8,
                ),

                widget.Sep(linewidth=1, padding=12, foreground=colors["muted"], background=colors["bg"]),

                widget.Clock(
                    format="%Y-%m-%d %a %I:%M %p",
                    foreground=colors["yellow"],
                    padding=10,
                    background=colors["bg"]
                ),
                widget.Systray(
                    padding=8,
                    icon_size=18,
                    background=colors["bg"]
                ),
            ],
            size=28,
            background=colors["bg"],
            margin=[0, 0, 0, 0],
            opacity=1.0,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(
                    scale=0.7,
                    padding=8,
                    foreground=colors["fg"],
                    background=colors["bg"],
                ),
            ],
            size=28,
            background=colors["bg"],
            margin=[0, 0, 0, 0],
            opacity=1.0,
        ),
    )
]

# ==================== MOUSE ====================
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),

    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# ==================== SETTINGS ====================
dgroups_key_binder = None
dgroups_app_rules: List = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"

# ==================== AUTOSTART ====================
@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    if os.path.exists(script):
        subprocess.Popen([script])
