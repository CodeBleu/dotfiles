# ~/.config/qtile/config.py
from typing import List, Any
qtile: Any
from libqtile import bar, layout, widget, hook
from libqtile.config import Key, Group, ScratchPad, Match, Screen, Drag, Click, DropDown
from libqtile.lazy import lazy
import subprocess, os

def get_num_monitors() -> int:
    """Count connected monitors via xrandr. Falls back to 1 on any failure."""
    try:
        out = subprocess.check_output(
            ["xrandr", "--query"], text=True, timeout=3
        )
        count = sum(1 for line in out.splitlines() if " connected" in line)
        return max(count, 1)
    except Exception:
        return 1

@hook.subscribe.startup_once
def set_wallpapers():
    import subprocess, os
    # 2. Let nitrogen seamlessly restore the independent scaled images
    # across your off-center screen arrangement
    subprocess.Popen(["nitrogen", "--restore"])

from libqtile.log_utils import logger
import threading

_screen_change_timer = None
_MONITOR_COUNT_FILE = "/tmp/qtile_last_monitor_count"

def _read_last_monitor_count():
    try:
        with open(_MONITOR_COUNT_FILE) as f:
            return int(f.read().strip())
    except Exception:
        return None

def _write_last_monitor_count(count):
    try:
        with open(_MONITOR_COUNT_FILE, "w") as f:
            f.write(str(count))
    except Exception:
        pass

def _apply_screen_change():
    """
    The actual work, run once ~1 second after the LAST screen_change event
    in a burst (see on_screen_change below for why this is debounced).

    IMPORTANT LOOP GUARD: qtile.restart() re-execs the whole process, and
    the fresh process detects the current screen layout as a "change" on
    startup, firing screen_change again immediately - which without a
    guard would restart forever. To prevent that, the current monitor
    count gets written to a small file, and a restart only happens if the
    count is actually different from what was last recorded. After a
    restart, the count matches what was just written, so the startup-time
    firing sees "no real change" and does nothing.
    """
    current_count = get_num_monitors()
    last_count = _read_last_monitor_count()

    if last_count == current_count:
        return

    _write_last_monitor_count(current_count)
    subprocess.run(["autorandr", "--change"])

    # NOTE: qtile 0.35 exposes this as restart() - the cmd_ prefix used in
    # older qtile versions was dropped. If you upgrade/downgrade qtile and
    # this starts throwing AttributeError again, check the log for the
    # exact error - it'll tell you the actual method name to use.
    from libqtile import qtile
    qtile.restart()

    subprocess.Popen(["nitrogen", "--restore"])

@hook.subscribe.screen_change
def on_screen_change(*args, **kwargs):
    """
    Fires whenever xrandr sees a monitor connected/disconnected. A single
    physical plug/unplug typically fires this MANY times in quick
    succession (mode negotiation, EDID reads, etc - your log showed ~15-20
    firings for one hotplug), so instead of acting immediately, this
    resets a 1-second timer on every firing and only actually runs
    _apply_screen_change() once things go quiet for a full second.
    """
    global _screen_change_timer
    if _screen_change_timer is not None:
        _screen_change_timer.cancel()
    _screen_change_timer = threading.Timer(1.0, _apply_screen_change)
    _screen_change_timer.start()

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
    "green": "#36C36B",
    "aqua": "#2EC7CC",
    "blue": "#0044FF",
    "purple": "#A855F7",
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
    Key([mod, "shift"], "k", lazy.layout.grow(), desc="Grow window"),
    Key([mod, "shift"], "j", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod, "shift"], "h", lazy.layout.grow_main(), desc="Grow main pane"),
    Key([mod, "shift"], "l", lazy.layout.shrink_main(), desc="Shrink main pane"),
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
    Key(["control", "mod1"], "l", lazy.spawn("sh -c 'light-locker-command -l'"), desc="Lock screen"),

    # Switch focus between physical monitors natively
    Key([mod], "o", lazy.next_screen(), desc="Move focus to next screen"),
    Key([mod], "i", lazy.prev_screen(), desc="Move focus to previous screen"),

    # Scalable group cycling - works no matter how many groups you have.
    # This is the safe way to move beyond 9 groups (see note below on why
    # numeric key bindings top out at 10).
    Key([mod], "bracketright", lazy.screen.next_group(), desc="Next group"),
    Key([mod], "bracketleft", lazy.screen.prev_group(), desc="Previous group"),

    # Shift the focused window to the group immediately after/before the
    # current one in `group_names`. Works by position in the list rather
    # than int() math, so it's safe now that group names can be letters
    # ("a", "s", ...) as well as numbers.
    Key([mod, "control", "shift"], "l",
        lazy.window.function(lambda w: w.togroup(
            group_names[group_names.index(w.group.name) + 1], switch_group=True
        ) if group_names.index(w.group.name) < len(group_names) - 1 else None),
        desc="Shift window right"),
    Key([mod, "control", "shift"], "h",
        lazy.window.function(lambda w: w.togroup(
            group_names[group_names.index(w.group.name) - 1], switch_group=True
        ) if group_names.index(w.group.name) > 0 else None),
        desc="Shift window left"),
]

# ==================== GROUPS ====================
# IMPORTANT: Key() bindings require a valid X keysym name. "1".."9" and "0"
# are valid single keysyms, but "10", "11", etc are NOT valid keysym names.
# Binding Key([mod], "10", ...) fails keysym lookup, which breaks qtile's
# config load entirely -> X session fails to start -> you get bounced back
# to lightdm. This is why the pool below sticks to single characters only.
#
# GROUPS_PER_MONITOR groups are created for EACH connected monitor, so the
# total group count scales automatically: 1 monitor = 4 groups, 2 = 8,
# 3 = 12, etc. This is recalculated on every qtile restart (including the
# automatic one from the screen_change hook), so plugging in another
# monitor and letting autorandr/qtile restart will grow the group count
# without editing this file.
#
# KEY_POOL is the order groups get named in: digits first, then a hand
# -picked set of letters that don't collide with any letter already bound
# under `mod` elsewhere in this file (b, f, h, i, j, k, l, n, o, q, r are
# all taken, so they're deliberately excluded here). Add more letters to
# the end of this pool if you ever need more than 25 total groups.
KEY_POOL = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "a", "s", "d", "g", "e", "c", "m", "p", "t", "u",
    "v", "w", "x", "y", "z",
]
GROUPS_PER_MONITOR = 4

_total_groups = min(GROUPS_PER_MONITOR * get_num_monitors(), len(KEY_POOL))
group_names = KEY_POOL[:_total_groups]
groups = [Group(i) for i in group_names]

groups.append(
    ScratchPad("scratch", [
        DropDown(
            "quake",
            "alacritty --class Alacritty",
            width=1,
            height=1,
            x=0,
            y=0,
            opacity=.96,
            on_focus_lost_hide=False,
        )
    ])
)

# ==================== KEYBINDINGS FOR GROUPS ====================
for g in groups:
    # Skip the scratchpad so it doesn't break our number math
    if g.name == "scratch":
        continue

    keys.extend([
        # Mod + <key> = Switch to workspace
        Key([mod], g.name, lazy.group[g.name].toscreen(),
            desc=f"Switch to group {g.name}"),

        # Mod + Shift + <key> = Move window to workspace
        Key([mod, "shift"], g.name, lazy.window.togroup(g.name, switch_group=True),
            desc=f"Move window to group {g.name}"),
    ])

@hook.subscribe.startup
def prune_stale_groups():
    """
    Runs on EVERY qtile startup, including the internal restarts triggered
    by on_screen_change - this is the real fix for groups not shrinking
    after a monitor is unplugged.

    Why this is needed: qtile.restart() preserves session state across the
    restart, and it turns out that preservation keeps EVERY previously
    existing group around (even empty ones), not just groups that still
    have windows - it only naturally drops whichever group was actively
    displayed on a screen that no longer exists. So after going from 3
    monitors/12 groups down to 1 monitor/4 groups, you'd still see ~11
    leftover empty groups instead of 4.

    This hook cleans that up: after every startup, anything not in the
    current `group_names` (or the scratchpad) gets deleted - but ONLY if
    it's actually empty. A stale group that still has real windows on it
    is left alone, so you never lose access to a window this way.
    """
    from libqtile import qtile
    valid_names = set(group_names) | {"scratch"}
    for g in list(qtile.groups):
        if g.name in valid_names:
            continue
        if g.windows:
            continue
        try:
            qtile.delete_group(g.name)
        except Exception as e:
            logger.warning(f"Failed to prune stale group '{g.name}': {e}")

# ==================== LAYOUTS ====================
layouts = [
    layout.MonadWide(
        margin=8,
        border_focus=colors["blue"],
        border_normal=colors["muted"],
        border_width=2,
        ratio=0.6,
    ),
    layout.Max(),
    layout.Floating(),
    layout.MonadTall(
        margin=8,
        border_focus=colors["blue"],
        border_normal=colors["muted"],
        border_width=2,
        ratio=0.6,
    ),
    layout.Columns(
        margin=2,
        border_width=2,
        border_focus=colors["blue"],
        border_normal=colors["muted"],
    ),
    layout.Max(),
    layout.Floating(),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_type="dialog"),
        Match(title="Confirmation"),
        Match(wm_class="zoom"),
        Match(title="Zoom Meeting"),
        Match(title="Zoom - Free Account"),
        Match(title="zoom"),
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

# ==================== DYNAMIC SCREEN / BAR GENERATION ====================
# Instead of hand-copying a Screen(...) block per monitor, we build one
# Screen per detected monitor (get_num_monitors() is defined up near the
# top of the file, right before KEYBINDINGS, since GROUPS needs it too).

def make_groupbox():
    return widget.GroupBox(
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
    )


def make_sep():
    return widget.Sep(linewidth=1, padding=12, foreground=colors["muted"], background=colors["bg"])


def make_clock():
    """
    Returns a LIST of widgets (not one) so date and time can be styled
    slightly differently without any background box - just a muted date
    and a bold yellow time, both sitting flat on the bar. Callers should
    splat this into the widgets list: *make_clock()
    """
    return [
        widget.Clock(
            format="%Y-%m-%d %a",
            font="DejaVu Sans Mono",
            fontsize=12,
            foreground=colors["muted"],
            background=colors["bg"],
            padding=8,
        ),
        widget.Clock(
            format="%I:%M %p",
            font="DejaVu Sans Mono Bold",
            fontsize=13,
            foreground=colors["yellow"],
            background=colors["bg"],
            padding=8,
        ),
    ]


def make_bar(primary: bool):
    """
    Same bar everywhere - CPU, RAM, volume, battery, clock - on every
    screen. The one exception is Systray, which only gets added on the
    primary screen: running a systray on more than one bar at once is a
    known qtile limitation (tray icons can duplicate or misbehave), not
    a style choice, so it's kept singular here.
    """
    widgets = [
        make_groupbox(),
        make_sep(),
        widget.CurrentLayout(scale=0.7, padding=8, foreground=colors["fg"], background=colors["bg"]),
        widget.Spacer(background=colors["bg"]),
        widget.CPU(format='CPU: {load_percent}%', foreground=colors["orange"], background=colors["bg"]),
        widget.Memory(format='RAM: {MemUsed:.0f}M', foreground=colors["aqua"], background=colors["bg"]),
        make_sep(),
        widget.Volume(
            format='Vol: {volume}%',
            foreground=colors["purple"],
            background=colors["bg"],
            padding=8,
            update_interval=2,
            unmute_format='Vol: {volume}%',
            mute_format='Muted',
            mouse_callbacks={'Button3': lazy.spawn('pavucontrol')},
        ),
        make_sep(),
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
        make_sep(),
        *make_clock(),
    ]

    if primary:
        widgets.append(widget.Systray(padding=8, icon_size=18, background=colors["bg"]))

    return bar.Bar(
        widgets,
        size=28,
        background=colors["bg"],
        margin=[0, 0, 0, 0],
        opacity=1.0,
    )


# ==================== SCREENS ====================
# Builds one Screen per detected monitor - add a 4th, 5th monitor and this
# just picks it up on the next qtile restart, no editing required.
screens = [Screen(top=make_bar(primary=(i == 0))) for i in range(get_num_monitors())]

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
